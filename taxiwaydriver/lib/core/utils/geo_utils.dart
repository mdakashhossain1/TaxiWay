import 'package:geolocator/geolocator.dart';

/// Requests high-accuracy location permissions and returns the device's exact
/// GPS position from the hardware sensor, mirroring taxiway's geo_utils.dart.
Future<Position?> determineCurrentPosition() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 8),
      ),
    );
  } catch (_) {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }
}
