import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/driver_ride.dart';
import 'publish_gates.dart';

/// Publishes the active ride's live position and status to Firestore so the
/// rider app can track it in realtime (`live_trips/{rideId}`). The driver is
/// the moving party, so it owns the fine-grained status: it derives
/// en-route → arrived → in-progress from a geofence around the pickup and
/// drop-off, rather than the rider guessing from a timer.
///
/// A plain singleton (not a Riverpod provider) because the GPS subscription
/// must outlive the screen that starts it — the same reason
/// [DriverLocationTrackingService] takes a root container.
class TripPublisher {
  TripPublisher._();
  static final TripPublisher instance = TripPublisher._();

  static const collection = 'live_trips';
  static const _arriveRadiusKm = 0.08; // 80 m: close enough to count as "at pickup"
  static const _departRadiusKm = 0.15; // 150 m past pickup: the ride has started

  StreamSubscription<Position>? _sub;
  String? _rideId;
  _Phase _phase = _Phase.enRoute;
  final _gate = IntervalGate(const Duration(seconds: 3));

  bool get isPublishing => _rideId != null;

  /// Begins publishing for [ride]. Idempotent for the same ride; switching
  /// rides stops the previous one first. [ensureSignedIn] authenticates with
  /// Firebase (reuse the chat repository's sign-in) so Firestore rules pass.
  Future<void> start({
    required DriverRide ride,
    required Future<void> Function() ensureSignedIn,
  }) async {
    if (_rideId == ride.id) return;
    await stop();

    try {
      await ensureSignedIn();
    } catch (_) {
      return; // without auth the writes would be rejected; try again next accept
    }

    _rideId = ride.id;
    _phase = _Phase.enRoute;
    _gate.reset();

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 15,
      ),
    ).listen(
      (pos) => _publish(ride, pos),
      onError: (_) {},
    );
  }

  Future<void> _publish(DriverRide ride, Position pos) async {
    final toPickupKm = _haversineKm(pos.latitude, pos.longitude, ride.pickupLat, ride.pickupLng);
    final toDestKm = _haversineKm(pos.latitude, pos.longitude, ride.destinationLat, ride.destinationLng);

    final phaseBefore = _phase;
    _advancePhase(toPickupKm);

    if (!_gate.due(DateTime.now(), force: _phase != phaseBefore)) return;

    final tripKm = _haversineKm(ride.pickupLat, ride.pickupLng, ride.destinationLat, ride.destinationLng);

    final data = <String, dynamic>{
      'status': _phase.apiStatus,
      'driverLat': pos.latitude,
      'driverLng': pos.longitude,
      'driverHeading': pos.heading,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (_phase == _Phase.inProgress) {
      data['routeProgress'] = tripKm <= 0 ? 0.0 : (1 - toDestKm / tripKm).clamp(0.0, 1.0);
    }

    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(ride.id)
          .set(data, SetOptions(merge: true));
    } catch (_) {
      // Non-fatal — the next position fix retries.
    }
  }

  void _advancePhase(double toPickupKm) {
    switch (_phase) {
      case _Phase.enRoute:
        if (toPickupKm <= _arriveRadiusKm) _phase = _Phase.arrived;
        break;
      case _Phase.arrived:
        if (toPickupKm >= _departRadiusKm) _phase = _Phase.inProgress;
        break;
      case _Phase.inProgress:
        break;
    }
  }

  /// Writes a terminal status and stops publishing. Call with completed:true
  /// from the driver's "Mark Completed" action.
  Future<void> stop({bool completed = false}) async {
    final rideId = _rideId;
    await _sub?.cancel();
    _sub = null;
    _rideId = null;
    if (completed && rideId != null) {
      try {
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(rideId)
            .set({'status': 'completed', 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      } catch (_) {}
    }
  }
}

enum _Phase {
  enRoute,
  arrived,
  inProgress;

  String get apiStatus => switch (this) {
        _Phase.enRoute => 'driver_en_route',
        _Phase.arrived => 'driver_arrived',
        _Phase.inProgress => 'ride_in_progress',
      };
}

double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const earthRadiusKm = 6371.0;
  double rad(double d) => d * (pi / 180);
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final h = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLng / 2) * sin(dLng / 2) * cos(rad(lat1)) * cos(rad(lat2));
  return earthRadiusKm * 2 * atan2(sqrt(h), sqrt(1 - h));
}
