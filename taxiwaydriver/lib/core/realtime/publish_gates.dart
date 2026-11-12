import 'package:geolocator/geolocator.dart';

typedef DistanceMeters = double Function(double lat1, double lng1, double lat2, double lng2);

/// Lets a write through only when enough time has passed since the last one,
/// or when the caller says the change is too important to wait.
class IntervalGate {
  IntervalGate(this.minInterval);

  final Duration minInterval;
  DateTime? _lastAt;

  bool due(DateTime now, {bool force = false}) {
    final last = _lastAt;
    if (!force && last != null && now.difference(last) < minInterval) return false;
    _lastAt = now;
    return true;
  }

  void reset() => _lastAt = null;
}

/// Decides when a driver's presence document needs rewriting: when they have
/// moved, when their availability flipped, or often enough that readers still
/// treat the document as fresh.
class PresenceGate {
  PresenceGate({
    this.minMoveMeters = 20,
    this.keepAlive = const Duration(seconds: 45),
    DistanceMeters? distance,
  }) : _distance = distance ?? Geolocator.distanceBetween;

  final double minMoveMeters;
  final Duration keepAlive;
  final DistanceMeters _distance;

  DateTime? _lastAt;
  double? _lastLat;
  double? _lastLng;
  bool? _lastAvailable;

  bool due(DateTime now, {required double lat, required double lng, required bool available}) {
    final lastAt = _lastAt;
    final lastLat = _lastLat;
    final lastLng = _lastLng;
    final moved = lastLat == null || lastLng == null ? double.infinity : _distance(lastLat, lastLng, lat, lng);

    final needed = lastAt == null ||
        available != _lastAvailable ||
        moved >= minMoveMeters ||
        now.difference(lastAt) >= keepAlive;
    if (!needed) return false;

    _lastAt = now;
    _lastLat = lat;
    _lastLng = lng;
    _lastAvailable = available;
    return true;
  }

  void reset() => _lastAt = null;
}
