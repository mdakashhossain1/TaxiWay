import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../api/network_failure.dart';
import '../models/booking.dart';
import '../models/driver.dart';
import '../models/fare_breakdown.dart';
import '../models/place_location.dart';
import '../models/vehicle.dart';
import '../models/vehicle_category.dart';
import '../geo/geo_index.dart';
import '../realtime/trip_channel.dart';
import '../utils/geo_utils.dart';

/// Creates real bookings against the backend and then tracks the live trip.
///
/// The driver-approach sub-statuses (en route / arrived / ride started / in
/// progress) are driven by the realtime [TripChannel]: the driver app
/// publishes its GPS position and status to Firestore and this controller maps
/// each push onto [state]. When no live document has appeared yet — the driver
/// app on an older build, a dropped connection — it falls back to the original
/// client-side timer simulation so the rider still sees a moving approach.
/// Only the driver's authoritative "Mark Completed" (in taxiwaydriver) ends a
/// ride server-side.
class BookingController extends Notifier<Booking?> {
  Timer? _timer;
  final List<Timer> _delayedTimers = [];

  StreamSubscription<TripLiveUpdate>? _liveSub;
  String? _liveBookingId;
  Timer? _fallbackTimer;
  bool _liveReceived = false;

  // ~20 km/h average city speed, used to turn a straight-line distance into a
  // rough ETA until the backend sends a real routed one.
  static const _cityKmh = 20.0;

  @override
  Booking? build() => null;

  Future<Booking> createBooking({
    required PlaceLocation pickup,
    required PlaceLocation destination,
    required VehicleCategory vehicleCategory,
    required double distanceKm,
    required int etaMinutes,
    required FareBreakdown fare,
    DateTime? scheduledAt,
    String? email,
  }) async {
    _resetAll();

    List<String>? pickupCells;
    try {
      pickupCells = (await GeoIndex.instance()).diskCells(pickup.latitude, pickup.longitude, ringSize: 1);
    } catch (_) {
      // H3 unavailable — the backend falls back to any eligible driver.
    }

    final response = await _createOrRecover(pickup, destination, vehicleCategory, {
      'pickup_address': pickup.address,
      'pickup_lat': pickup.latitude,
      'pickup_lng': pickup.longitude,
      'pickup_h3_cells': ?pickupCells,
      'destination_address': destination.address,
      'destination_lat': destination.latitude,
      'destination_lng': destination.longitude,
      'vehicle_category_id': vehicleCategory.categoryId,
      'distance_km': distanceKm,
      'eta_minutes': etaMinutes,
      'payment_method': 'cash',
      if (scheduledAt != null) 'type': 'scheduled',
      if (scheduledAt != null) 'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      if (email != null && email.isNotEmpty) 'email': email,
    });

    var booking = Booking.fromJson(response['data'] as Map<String, dynamic>).copyWith(
      driverDistanceKm: 2.4,
      driverEtaMinutes: 6,
    );

    if (booking.driver != null) {
      booking = await _enrichWithFullDriverProfile(booking);
    }

    state = booking;

    // Subscribe to the live feed immediately, independent of the push — so a
    // trip advances even if the driver_accepted notification is missed.
    _startLive(booking.id);

    return booking;
  }

  static const _openStatuses = {
    'requested',
    'allocating',
    'scheduled_open',
    'driver_offered',
    'driver_assigned',
    'driver_en_route',
    'driver_arrived',
    'ride_started',
    'ride_in_progress',
  };

  /// A booking request that times out may still have reached the server, with
  /// only the reply lost. Retrying blindly would book twice, so before giving
  /// up we look for a booking that matches this exact request.
  Future<Map<String, dynamic>> _createOrRecover(
    PlaceLocation pickup,
    PlaceLocation destination,
    VehicleCategory category,
    Map<String, dynamic> body,
  ) async {
    try {
      return await ApiClient.instance.post('/customer/bookings', body: body);
    } on NetworkFailure catch (failure) {
      if (failure.kind != NetworkFailureKind.timeout) rethrow;
      final existing = await _findJustCreated(pickup, destination, category);
      if (existing == null) rethrow;
      return {'data': existing};
    }
  }

  Future<Map<String, dynamic>?> _findJustCreated(
    PlaceLocation pickup,
    PlaceLocation destination,
    VehicleCategory category,
  ) async {
    try {
      final response = await ApiClient.instance.get('/customer/bookings');
      final cutoff = DateTime.now().toUtc().subtract(const Duration(minutes: 3));
      for (final item in response['data'] as List) {
        final json = item as Map<String, dynamic>;
        final createdAt = DateTime.tryParse(json['created_at'] as String? ?? '');
        if (createdAt == null || createdAt.toUtc().isBefore(cutoff)) continue;
        if (!_openStatuses.contains(json['status'])) continue;
        if ('${json['vehicle_category_id']}' != '${category.categoryId}') continue;
        if (_sameSpot(json, 'pickup', pickup) && _sameSpot(json, 'destination', destination)) return json;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  bool _sameSpot(Map<String, dynamic> json, String prefix, PlaceLocation place) {
    final lat = double.tryParse('${json['${prefix}_lat']}');
    final lng = double.tryParse('${json['${prefix}_lng']}');
    if (lat == null || lng == null) return false;
    return (lat - place.latitude).abs() < 1e-5 && (lng - place.longitude).abs() < 1e-5;
  }

  /// Called when a "driver_accepted" push arrives for the active booking.
  /// Re-fetches authoritative state (the create-booking response may only
  /// have shown a not-yet-accepted *offer*) and begins live tracking, arming
  /// the fallback simulation in case no live document is ever published.
  Future<void> applyDriverAccepted() async {
    final current = state;
    if (current == null) return;

    try {
      final response = await ApiClient.instance.get('/customer/bookings/${current.id}');
      var booking = Booking.fromJson(response['data'] as Map<String, dynamic>).copyWith(
        driverDistanceKm: 2.4,
        driverEtaMinutes: 6,
      );

      if (booking.driver != null) {
        booking = await _enrichWithFullDriverProfile(booking);
      }

      state = booking;
      _startLive(booking.id);

      // Scheduled rides can be accepted hours or days ahead of pickup, so the
      // "driver en route" countdown would be wrong — a scheduled ride just
      // shows "confirmed" until pickup. Instant rides arm the fallback sim,
      // which only runs if the live feed stays silent.
      if (booking.status == BookingStatus.driverAssigned && !booking.isScheduled) {
        _armFallback();
      }
    } on ApiException {
      // Non-fatal — the live feed and/or a later manual refresh still advance
      // the booking.
    }
  }

  /// The create-booking response's driver/vehicle are lightweight (no
  /// vehicle photos/videos, no reviews). Fetch the full profile once so the
  /// Driver & Vehicle Profile / Full Profile / Gallery screens have real
  /// media and reviews to show.
  Future<Booking> _enrichWithFullDriverProfile(Booking booking) async {
    try {
      final response = await ApiClient.instance.get('/customer/bookings/${booking.id}/driver');
      final driverJson = response['data'] as Map<String, dynamic>;
      final fullDriver = Driver.fromJson(driverJson);

      Vehicle? enrichedVehicle = booking.vehicle;
      final vehiclesJson = driverJson['vehicles'] as List?;
      if (vehiclesJson != null && vehiclesJson.isNotEmpty) {
        final match = vehiclesJson.firstWhere(
          (v) => (v as Map<String, dynamic>)['id'].toString() == booking.vehicle?.id,
          orElse: () => vehiclesJson.first,
        ) as Map<String, dynamic>;
        enrichedVehicle = Vehicle.fromJson(
          match,
          categoryName: booking.vehicleCategory.name,
          seats: booking.vehicleCategory.seats,
          ac: booking.vehicleCategory.ac,
        );
      }

      return booking.copyWith(driver: fullDriver, vehicle: enrichedVehicle);
    } on ApiException {
      return booking;
    }
  }

  // ---- Live trip feed --------------------------------------------------

  void _startLive(String bookingId) {
    if (_liveBookingId == bookingId && _liveSub != null) return;
    _stopLive();
    _liveBookingId = bookingId;
    _liveReceived = false;
    _liveSub = ref.read(tripChannelProvider).watch(bookingId).listen(
          _applyLive,
          onError: (_) {}, // a feed error just leaves the fallback sim in charge
        );
  }

  void _applyLive(TripLiveUpdate update) {
    final current = state;
    if (current == null || update.isEmpty) return;

    // The first real signal means the driver app is publishing live — cancel
    // the fallback simulation and any timers it may already be running.
    _liveReceived = true;
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
    _cancelSimTimers();

    final status = update.status ?? current.status;
    var next = current;

    if (update.hasDriverLocation && status != BookingStatus.completed) {
      final driverPos = PlaceLocation(
        latitude: update.driverLat!,
        longitude: update.driverLng!,
        address: '',
      );
      if (status == BookingStatus.rideStarted || status == BookingStatus.rideInProgress) {
        final toDest = haversineKm(driverPos, next.destination);
        final total = next.distanceKm <= 0 ? toDest : next.distanceKm;
        final progress = update.routeProgress ?? (total <= 0 ? 0.0 : (1 - toDest / total));
        next = next.copyWith(
          routeProgress: progress.clamp(0.0, 1.0).toDouble(),
          driverLat: update.driverLat,
          driverLng: update.driverLng,
        );
      } else {
        final toPickup = haversineKm(driverPos, next.pickup);
        next = next.copyWith(
          driverDistanceKm: toPickup,
          driverEtaMinutes: (toPickup / _cityKmh * 60).round().clamp(0, 999),
          driverLat: update.driverLat,
          driverLng: update.driverLng,
        );
      }
    }

    if (update.status != null && update.status != next.status) {
      next = next.copyWith(status: update.status);
    }

    state = next;

    if (status == BookingStatus.completed || status == BookingStatus.cancelled) {
      _stopLive();
    }
  }

  void _armFallback() {
    _fallbackTimer?.cancel();
    // Give the live feed a few seconds to produce the first update before the
    // simulation takes over.
    _fallbackTimer = Timer(const Duration(seconds: 8), () {
      if (_liveReceived) return;
      final b = state;
      if (b != null && b.status == BookingStatus.driverAssigned && !b.isScheduled) {
        _toDriverEnRoute();
      }
    });
  }

  void _stopLive() {
    _liveSub?.cancel();
    _liveSub = null;
    _liveBookingId = null;
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
  }

  // ---- Fallback simulation (only runs when the live feed is silent) ----

  void _toDriverEnRoute() {
    if (state == null) return;
    state = state!.copyWith(status: BookingStatus.driverEnRoute);
    _timer?.cancel();
    var ticks = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final b = state;
      if (b == null || b.status != BookingStatus.driverEnRoute) {
        t.cancel();
        return;
      }
      ticks++;
      final newDist = (b.driverDistanceKm - 0.2).clamp(0.0, 999.0);
      final newEta = ticks % 3 == 0 ? (b.driverEtaMinutes - 1).clamp(0, 999) : b.driverEtaMinutes;
      if (newDist <= 0) {
        t.cancel();
        state = b.copyWith(status: BookingStatus.driverArrived, driverDistanceKm: 0, driverEtaMinutes: 0);
        _runAfter(const Duration(seconds: 3), _toRideStarted);
      } else {
        state = b.copyWith(driverDistanceKm: newDist, driverEtaMinutes: newEta);
      }
    });
  }

  void _toRideStarted() {
    if (state == null) return;
    state = state!.copyWith(status: BookingStatus.rideStarted);
    _runAfter(const Duration(milliseconds: 600), _toRideInProgress);
  }

  void _toRideInProgress() {
    if (state == null) return;
    state = state!.copyWith(status: BookingStatus.rideInProgress);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final b = state;
      if (b == null || b.status != BookingStatus.rideInProgress) {
        t.cancel();
        return;
      }
      final newProgress = (b.routeProgress + 0.1).clamp(0.0, 1.0);
      if (newProgress >= 1.0) {
        t.cancel();
        state = b.copyWith(status: BookingStatus.completed, routeProgress: 1.0);
      } else {
        state = b.copyWith(routeProgress: newProgress);
      }
    });
  }

  void _runAfter(Duration delay, void Function() action) {
    final timer = Timer(delay, action);
    _delayedTimers.add(timer);
  }

  void _cancelSimTimers() {
    _timer?.cancel();
    _timer = null;
    for (final t in _delayedTimers) {
      t.cancel();
    }
    _delayedTimers.clear();
  }

  void _resetAll() {
    _cancelSimTimers();
    _stopLive();
    _liveReceived = false;
  }

  void cancelBooking() {
    _resetAll();
    final current = state;
    if (current != null) {
      state = current.copyWith(status: BookingStatus.cancelled);
      ApiClient.instance.post('/customer/bookings/${current.id}/cancel').catchError((_) => <String, dynamic>{});
    }
  }

  void clear() {
    _resetAll();
    state = null;
  }
}
