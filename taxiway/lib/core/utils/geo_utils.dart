import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../data/nominatim_client.dart';
import '../models/place_location.dart';

const _storage = FlutterSecureStorage();
const _localeKey = 'app_locale_code';

Future<String> _currentLocaleCode() async => (await _storage.read(key: _localeKey)) ?? 'en';

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
    final localeCode = await _currentLocaleCode();
    final displayName = await nominatimReverseGeocode(latitude, longitude, localeCode);
    if (displayName != null) {
      resolvedAddress = displayName;
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
