import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/api/native_secrets.dart';
import 'core/router/app_router.dart';
import 'core/services/push_notification_service.dart';
import 'core/state/locale_controller.dart';
import 'core/state/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must resolve before any signed API call — see native_secrets.dart.
  await NativeSecrets.load();
  // Reads android/app/google-services.json and ios/Runner/GoogleService-Info.plist
  // natively — no generated firebase_options.dart needed for mobile.
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Debug builds crash locally and print to console instead of polluting
  // Crashlytics with dev-machine noise.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: TaxiwayApp()));
}

class TaxiwayApp extends ConsumerWidget {
  const TaxiwayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).locale;
    final themeState = ref.watch(themeControllerProvider);

    // Gates the very first frame until the persisted theme preference has
    // loaded — ThemeProvider only reads initTheme once, in initState, so a
    // late-arriving "dark" preference would otherwise never actually apply.
    if (themeState.loading) {
      return const MaterialApp(debugShowCheckedModeBanner: false, home: SizedBox.shrink());
    }

    return ThemeProvider(
      initTheme: themeState.isDark ? AppTheme.dark : AppTheme.light,
      // Longer than the package default (300ms) — a full-screen circular
      // wipe needs a bit more time to read as smooth rather than snappy.
      duration: const Duration(milliseconds: 450),
      builder: (context, theme) => ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Taxiway',
          debugShowCheckedModeBanner: false,
          theme: theme,
          routerConfig: appRouter,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => ThemeSwitchingArea(child: child!),
        ),
      ),
    );
  }
}
