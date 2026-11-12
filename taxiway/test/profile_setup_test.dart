import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiway/core/data/auth_repository.dart';
import 'package:taxiway/core/providers.dart';
import 'package:taxiway/core/router/app_router.dart';
import 'package:taxiway/core/state/auth_controller.dart';
import 'package:taxiway/core/theme/app_theme.dart';
import 'package:taxiway/core/widgets/animated_success_check.dart';
import 'package:taxiway/core/widgets/buttons.dart';
import 'package:taxiway/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:taxiway/l10n/generated/app_localizations.dart';

class _NoRepo implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAuth extends AuthController {
  _FakeAuth() : super(_NoRepo());

  @override
  AuthState build() => const AuthState();

  @override
  Future<void> completeProfile({required String name, String? email}) async {}
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  for (final locale in const [Locale('en'), Locale('hi'), Locale('bn')]) {
    for (final config in const [(Size(320, 568), 1.3), (Size(360, 740), 1.0)]) {
      final size = config.$1;
      final scale = config.$2;
      testWidgets('sign-up flow ${locale.languageCode} ${size.width.toInt()}x${size.height.toInt()} x$scale', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final router = GoRouter(
          initialLocation: AppRoutes.profileSetup,
          routes: [
            GoRoute(path: AppRoutes.profileSetup, builder: (_, _) => const ProfileSetupScreen()),
            GoRoute(path: AppRoutes.home, builder: (_, _) => const Text('HOME_REACHED')),
            GoRoute(path: AppRoutes.login, builder: (_, _) => const Text('LOGIN')),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [authControllerProvider.overrideWith(_FakeAuth.new)],
            child: MaterialApp.router(
              routerConfig: router,
              theme: AppTheme.light,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 800));

        final fields = find.byType(TextField);
        await tester.enterText(fields.at(0), 'ravi kumar');
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('R'), findsOneWidget, reason: 'avatar shows the initial');

        await tester.enterText(fields.at(1), 'abc');
        await tester.pump();
        await tester.ensureVisible(find.byType(PrimaryButton));
        await tester.tap(find.byType(PrimaryButton));
        await tester.pump(const Duration(milliseconds: 400));
        final l10n = await AppLocalizations.delegate.load(locale);
        expect(find.text(l10n.validationEmailInvalid), findsOneWidget, reason: 'inline email error');
        expect(find.byType(AnimatedSuccessCheck), findsNothing);

        await tester.enterText(fields.at(1), 'ravi@example.com');
        await tester.pump();
        await tester.tap(find.byType(PrimaryButton));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 900));
        expect(find.byType(AnimatedSuccessCheck), findsOneWidget, reason: 'welcome state');
        expect(find.text(l10n.profileSavedTitle('ravi')), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('HOME_REACHED'), findsOneWidget, reason: 'auto-navigates home');
      });
    }
  }
}
