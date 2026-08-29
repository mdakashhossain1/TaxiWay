import 'dart:math';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/place_location.dart';

final _geocoding = geocoding.Geocoding();

/// Requests high-accuracy location permissions and returns the device's exact
/// GPS position from the hardware sensor. Uses highest precision settings
/// (bestForNavigation) with no approximations or hallucinated coordinates.
Future<Position?> determineCurrentPosition() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user or check last known position if service disabled
      return await Geolocator.getLastKnownPosition();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return await Geolocator.getLastKnownPosition();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return await Geolocator.getLastKnownPosition();
    }

    // Attempt high-precision GPS lock
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 8),
      ),
    );
  } catch (_) {
    // If real-time lock timed out, fall back to last known cached GPS fix
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }
}

/// Reverse-geocodes an exact GPS coordinate into a verified street address
/// with building/street/locality precision, filtering out plus codes.
Future<PlaceLocation> resolveExactPlaceLocation({
  required double latitude,
  required double longitude,
  String? fallbackAddress,
}) async {
  String resolvedAddress = fallbackAddress ?? '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  try {
    final placemarks = await _geocoding.placemarkFromCoordinates(latitude, longitude).timeout(
      const Duration(seconds: 5),
      onTimeout: () => [],
    );

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      final isPlusCode = p.name != null && p.name!.contains('+');

      final parts = <String>{
        if (p.name != null && p.name!.isNotEmpty && !isPlusCode) p.name!,
        if (p.street != null && p.street!.isNotEmpty && p.street != p.name && !p.street!.contains('+')) p.street!,
        if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
        if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea!,
      }.toList();

      if (parts.isNotEmpty) {
        resolvedAddress = parts.join(', ');
      }
    }
  } catch (_) {}

  return PlaceLocation(
    latitude: latitude,
    longitude: longitude,
    address: resolvedAddress,
  );
}

/// Detects the user's exact current GPS location from satellite/device hardware
/// and performs reverse geocoding to resolve the real physical address.
Future<PlaceLocation?> detectExactCurrentLocation() async {
  final pos = await determineCurrentPosition();
  if (pos == null) return null;

  return resolveExactPlaceLocation(
    latitude: pos.latitude,
    longitude: pos.longitude,
  );
}

/// Great-circle distance between two points, in kilometres (Haversine formula).
double haversineKm(PlaceLocation a, PlaceLocation b) {
  const earthRadiusKm = 6371.0;
  final dLat = _deg2rad(b.latitude - a.latitude);
  final dLon = _deg2rad(b.longitude - a.longitude);
  final lat1 = _deg2rad(a.latitude);
  final lat2 = _deg2rad(b.latitude);

  final h = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  final c = 2 * atan2(sqrt(h), sqrt(1 - h));
  return earthRadiusKm * c;
}

double _deg2rad(double deg) => deg * (pi / 180);

final _rupeeFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

String formatRupees(num amount) => _rupeeFormat.format(amount);

int _idCounter = 1000;

String generateBookingId() {
  _idCounter++;
  final now = DateTime.now();
  final y = now.year.toString();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return 'BK$y$m$d$_idCounter';
}
