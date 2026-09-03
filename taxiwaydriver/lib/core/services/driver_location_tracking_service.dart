import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/location_repository.dart';
import '../utils/geo_utils.dart';

/// Captures the driver's real hardware GPS position and reports it to the
/// backend while the app is in the foreground. Started right after login
/// (see otp_verification_screen/phone_login_screen, alongside
/// PushNotificationService.initialize) and stopped on logout — there is no
/// background/online-offline mode yet, so tracking only runs while the app
/// is actually open.
class DriverLocationTrackingService {
  DriverLocationTrackingService._();

  static const _interval = Duration(seconds: 25);
  static Timer? _timer;

  static void start(WidgetRef ref) {
    if (_timer != null) return;
    _sendUpdate(ref);
    _timer = Timer.periodic(_interval, (_) => _sendUpdate(ref));
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> _sendUpdate(WidgetRef ref) async {
    final position = await determineCurrentPosition();
    if (position == null) return;
    try {
      await ref.read(locationRepositoryProvider).updateLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          );
    } catch (_) {
      // Non-fatal — the next tick retries; a missed update shouldn't disrupt the app.
    }
  }
}
