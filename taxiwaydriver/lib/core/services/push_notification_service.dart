import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/ride_repository.dart';
import '../router/app_router.dart';
import '../state/driver_rides_controller.dart';
import '../widgets/app_toast.dart';

/// Must be a top-level (or static) function, per firebase_messaging's
/// requirements, so it can run in the background isolate. No work is needed
/// here — Android renders the system-tray notification straight from the
/// payload's `notification` block when the app isn't in the foreground; this
/// only needs to exist for FCM to permit background delivery at all.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// Requests notification permission, registers/refreshes the device's FCM
/// token, and reacts to ride-related pushes — `ride_offer` drives the
/// driver straight to [IncomingRideOfferScreen]; everything else is
/// informational (shown via [AppToast] when the app is already open).
class PushNotificationService {
  PushNotificationService._();

  static bool _initialized = false;

  static Future<void> initialize(WidgetRef ref) async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    if (token != null) {
      await ref.read(authRepositoryProvider).registerDeviceToken(token);
    }
    messaging.onTokenRefresh.listen((newToken) {
      ref.read(authRepositoryProvider).registerDeviceToken(newToken);
    });

    FirebaseMessaging.onMessage.listen((message) => _handle(ref, message));
    FirebaseMessaging.onMessageOpenedApp.listen((message) => _handle(ref, message));

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) _handle(ref, initialMessage);
  }

  static Future<void> _handle(WidgetRef ref, RemoteMessage message) async {
    final type = message.data['type'];
    final bookingId = message.data['booking_id'] as String?;

    if (type == 'ride_offer' && bookingId != null) {
      ref.invalidate(pendingOfferProvider);
      try {
        final ride = await ref.read(rideRepositoryProvider).getRide(bookingId);
        appRouter.push(AppRoutes.rideOffer, extra: ride);
        return;
      } catch (_) {
        // Offer may have already expired/been taken by the time this ran —
        // fall through to the generic toast below.
      }
    }

    if (type == 'ride_assigned') {
      ref.invalidate(nextRideProvider);
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final title = message.notification?.title;
    final body = message.notification?.body;
    // Freshly read from the global key above, not captured before the
    // `await`s — safe despite the lint's conservative "any context after any
    // await in this function" heuristic.
    // ignore: use_build_context_synchronously
    if (body != null) AppToast.info(context, body, title: title);
  }
}
