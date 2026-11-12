import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository.dart';
import '../data/location_repository.dart';
import '../geo/geo_index.dart';
import '../realtime/publish_gates.dart';
import '../realtime/trip_publisher.dart';
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
  static final _presence = PresenceGate();

  /// Takes the root [ProviderContainer] rather than the caller's `WidgetRef`
  /// — the timer keeps firing long after the login screen that starts it is
  /// disposed, so a widget-scoped ref would throw on every later tick.
  static void start(ProviderContainer container) {
    if (_timer != null) return;
    _sendUpdate(container);
    _timer = Timer.periodic(_interval, (_) => _sendUpdate(container));
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
    _presence.reset();
  }

  static Future<void> _sendUpdate(ProviderContainer container) async {
    final position = await determineCurrentPosition();
    if (position == null) return;

    String? cell;
    try {
      cell = (await GeoIndex.instance()).cell(position.latitude, position.longitude);
    } catch (_) {
      // H3 native library unavailable — fall back to location-only reporting.
    }

    // Authoritative store the backend's driver allocation reads from.
    try {
      await container.read(locationRepositoryProvider).updateLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            h3Index: cell,
          );
    } catch (_) {
      // Non-fatal — the next tick retries; a missed update shouldn't disrupt the app.
    }

    // Live feed the rider app's nearby-driver search subscribes to. Only
    // published while H3 is available (the cell is the query key) and the
    // driver is signed in to Firebase. A driver already on a trip is marked
    // unavailable so they don't show as bookable.
    if (cell == null) return;
    final available = !TripPublisher.instance.isPublishing;
    if (!_presence.due(DateTime.now(), lat: position.latitude, lng: position.longitude, available: available)) return;
    try {
      final chat = container.read(chatRepositoryProvider);
      await chat.ensureSignedIn();
      final uid = chat.myUid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('driver_locations').doc(uid).set({
        'lat': position.latitude,
        'lng': position.longitude,
        'h3r8': cell,
        'available': available,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      _presence.reset();
      // Non-fatal — nearby display is best-effort; the REST update above is the
      // source of truth.
    }
  }
}
