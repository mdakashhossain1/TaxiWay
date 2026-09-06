import 'dart:async';

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
  static StreamSubscription<String>? _tokenRefreshSub;
  static StreamSubscription<RemoteMessage>? _onMessageSub;
  static StreamSubscription<RemoteMessage>? _onMessageOpenedSub;

  /// Takes the root [ProviderContainer] rather than the caller's `WidgetRef`
  /// — this runs for the app's lifetime (listeners, `onTokenRefresh`), well
  /// past the screen that triggers it, which gets disposed on navigation.
  static Future<void> initialize(ProviderContainer container) async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    if (token != null) {
      await container.read(authRepositoryProvider).registerDeviceToken(token);
    }
    _tokenRefreshSub = messaging.onTokenRefresh.listen((newToken) {
      container.read(authRepositoryProvider).registerDeviceToken(newToken);
    });

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) => _handle(container, message));
    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) => _handle(container, message));

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) _handle(container, initialMessage);
  }

  /// Call on logout so a different rider logging in on the same device gets
  /// their own token registration and push listeners instead of `initialize`
  /// silently no-op'ing and leaving the previous rider's wired up.
  static void reset() {
    _initialized = false;
    _tokenRefreshSub?.cancel();
    _onMessageSub?.cancel();
    _onMessageOpenedSub?.cancel();
    _tokenRefreshSub = null;
    _onMessageSub = null;
    _onMessageOpenedSub = null;
  }

  static void _handle(ProviderContainer container, RemoteMessage message) {
    final type = message.data['type'];

    if (type == 'driver_accepted') {
      container.read(bookingControllerProvider.notifier).applyDriverAccepted();
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final title = message.notification?.title;
    final body = message.notification?.body;
    if (body != null) AppToast.info(context, body, title: title);
  }
}
