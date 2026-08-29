import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/api/native_secrets.dart';
import 'core/router/app_router.dart';
import 'core/services/push_notification_service.dart';
import 'core/state/locale_controller.dart';
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
  runApp(const ProviderScope(child: DriverApp()));
}

class DriverApp extends ConsumerWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).locale;

    return MaterialApp.router(
      title: 'Taxiway Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
