import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../router/app_router.dart';
import '../widgets/app_toast.dart';

/// Must be a top-level (or static) function, per firebase_messaging's
/// requirements, so it can run in the background isolate. No work is needed
/// here — Android renders the system-tray notification straight from the
/// payload's `notification` block when the app isn't in the foreground; this
/// only needs to exist for FCM to permit background delivery at all.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// Requests notification permission, registers/refreshes the device's FCM
/// token, and reacts to ride-related pushes — `driver_accepted` drives the
/// real trigger for [BookingController.applyDriverAccepted]; everything else
/// is informational (shown via [AppToast] when the app is already open).
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

  static void _handle(WidgetRef ref, RemoteMessage message) {
    final type = message.data['type'];

    if (type == 'driver_accepted') {
      ref.read(bookingControllerProvider.notifier).applyDriverAccepted();
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final title = message.notification?.title;
    final body = message.notification?.body;
    if (body != null) AppToast.info(context, body, title: title);
  }
}
