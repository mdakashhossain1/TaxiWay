import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/booking.dart';
import '../models/driver.dart';
import '../models/fare_breakdown.dart';
import '../models/place_location.dart';
import '../models/vehicle.dart';
import '../models/vehicle_category.dart';

/// Creates real bookings against the backend (real driver/vehicle
/// allocation, real fare persisted) and cancels them for real too. The
/// driver-approach sub-statuses (en route / arrived / ride started / in
/// progress) stay a client-side timer simulation exactly as before — there
/// is no live GPS feed to drive them for real, and they were always a
/// cosmetic approximation even before this backend existed. Only the
/// *driver's* "Mark Completed" action (in taxiwaydriver) is authoritative for
/// actually finishing a ride server-side.
///
/// The one real trigger driving this simulation is the "driver accepted"
/// push notification: a booking's driver can be *offered* (and so already
/// present in the create-booking response) before that driver has actually
/// accepted, so the simulation no longer starts on booking creation — only
/// [applyDriverAccepted] (called by `PushNotificationService`) starts it.
class BookingController extends Notifier<Booking?> {
  Timer? _timer;
  final List<Timer> _delayedTimers = [];

  @override
  Booking? build() => null;

  Future<Booking> createBooking({
    required PlaceLocation pickup,
    required PlaceLocation destination,
    required VehicleCategory vehicleCategory,
    required double distanceKm,
    required int etaMinutes,
    required FareBreakdown fare,
  }) async {
    _cancelAllTimers();

    final response = await ApiClient.instance.post('/customer/bookings', body: {
      'pickup_address': pickup.address,
      'pickup_lat': pickup.latitude,
      'pickup_lng': pickup.longitude,
      'destination_address': destination.address,
      'destination_lat': destination.latitude,
      'destination_lng': destination.longitude,
      'vehicle_category_id': vehicleCategory.categoryId,
      'distance_km': distanceKm,
      'eta_minutes': etaMinutes,
      'payment_method': 'cash',
    });

    var booking = Booking.fromJson(response['data'] as Map<String, dynamic>).copyWith(
      driverDistanceKm: 2.4,
      driverEtaMinutes: 6,
    );

    if (booking.driver != null) {
      booking = await _enrichWithFullDriverProfile(booking);
    }

    state = booking;

    return booking;
  }

  /// Called when a "driver_accepted" push arrives for the active booking.
  /// Re-fetches authoritative state (the create-booking response may only
  /// have shown a not-yet-accepted *offer*) and, once truly assigned, starts
  /// the en-route simulation exactly as this used to do immediately on
  /// booking creation.
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

      if (booking.status == BookingStatus.driverAssigned) {
        _runAfter(const Duration(milliseconds: 900), _toDriverEnRoute);
      }
    } on ApiException {
      // Non-fatal — the booking screens keep polling-free but will simply
      // stay put until the customer manually checks back or refreshes.
    }
  }

  /// The create-booking response's driver/vehicle are lightweight (no
  /// vehicle photos/videos, no reviews). Fetch the full profile once so the
  /// Driver & Vehicle Profile / Full Profile / Gallery screens have real
  /// media and reviews to show, exactly like the mock data used to provide.
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
      // Non-fatal — the lighter driver/vehicle from the create response is
      // still perfectly usable, just without media/reviews.
      return booking;
    }
  }

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

  void _cancelAllTimers() {
    _timer?.cancel();
    _timer = null;
    for (final t in _delayedTimers) {
      t.cancel();
    }
    _delayedTimers.clear();
  }

  void cancelBooking() {
    _cancelAllTimers();
    final current = state;
    if (current != null) {
      state = current.copyWith(status: BookingStatus.cancelled);
      ApiClient.instance.post('/customer/bookings/${current.id}/cancel').catchError((_) => <String, dynamic>{});
    }
  }

  void clear() {
    _cancelAllTimers();
    state = null;
  }
}
