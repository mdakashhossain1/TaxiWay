import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiway/core/api/api_connectivity.dart';
import 'package:taxiway/core/api/network_failure.dart';
import 'package:taxiway/core/theme/app_theme.dart';
import 'package:taxiway/core/widgets/connectivity_banner.dart';
import 'package:taxiway/core/widgets/empty_state.dart';
import 'package:taxiway/core/widgets/network_error_view.dart';
import 'package:taxiway/core/widgets/page_state_builder.dart';
import 'package:taxiway/core/widgets/pressable_scale.dart';
import 'package:taxiway/l10n/generated/app_localizations.dart';

Widget app(Widget home, {Locale locale = const Locale('en'), double scale = 1.0, bool banner = false}) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        final scaled = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
        return banner ? ConnectivityBannerHost(child: scaled) : scaled;
      },
      home: home,
    ),
  );
}

void usePhoneSurface(WidgetTester tester, {Size size = const Size(360, 740)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() => ApiConnectivity.status.value = NetworkStatus.online);

  for (final locale in const [Locale('en'), Locale('hi'), Locale('bn')]) {
    testWidgets('banner cycles offline, back online, slow, server (${locale.languageCode}, 320 wide, x1.3)', (tester) async {
      usePhoneSurface(tester, size: const Size(320, 640));
      final l10n = await AppLocalizations.delegate.load(locale);

      await tester.pumpWidget(app(const Scaffold(body: Text('PAGE')), locale: locale, scale: 1.3, banner: true));
      await tester.pump();
      expect(find.text(l10n.connectionOfflineTitle), findsNothing);

      ApiConnectivity.status.value = NetworkStatus.offline;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionOfflineTitle), findsOneWidget);
      expect(find.text(l10n.connectionRetryAction), findsOneWidget);
      expect(find.text('PAGE'), findsOneWidget);

      ApiConnectivity.status.value = NetworkStatus.online;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionRestoredTitle), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionRestoredTitle), findsNothing, reason: 'recovery flash clears itself');

      ApiConnectivity.status.value = NetworkStatus.slowConnection;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionSlowTitle), findsOneWidget);
      expect(find.text(l10n.connectionRetryAction), findsNothing, reason: 'slow has no retry');
      await tester.pump(const Duration(seconds: 7));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionSlowTitle), findsNothing, reason: 'slow decays on its own');

      ApiConnectivity.status.value = NetworkStatus.serverError;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.connectionServerTroubleTitle), findsOneWidget);

      ApiConnectivity.status.value = NetworkStatus.online;
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('PageStateBuilder shows typed errors, keeps stale data, and retries on reconnect', (tester) async {
    usePhoneSurface(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    var retries = 0;

    Widget page(AsyncValue<int> value) => app(
          PageStateBuilder<int>(
            asyncValue: value,
            onRetry: () async => retries++,
            builder: (context, data) => Text('DATA $data'),
          ),
        );

    const offline = NetworkFailure(NetworkFailureKind.offline);
    const timeout = NetworkFailure(NetworkFailureKind.timeout);

    await tester.pumpWidget(page(AsyncError<int>(offline, StackTrace.empty)));
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text(l10n.errorOfflineTitle), findsOneWidget);
    expect(find.text(l10n.tryAgainLabel), findsOneWidget);

    await tester.pumpWidget(page(AsyncError<int>(timeout, StackTrace.empty)));
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text(l10n.errorTimeoutTitle), findsOneWidget);

    final staleError = (await tester.runAsync(() async {
      var refreshFails = false;
      final provider = FutureProvider<int>((ref) async {
        if (refreshFails) throw offline;
        return 7;
      });
      final container = ProviderContainer(retry: (retryCount, error) => null);
      addTearDown(container.dispose);
      await container.read(provider.future);
      refreshFails = true;
      container.invalidate(provider);
      await expectLater(container.read(provider.future), throwsA(isA<NetworkFailure>()));
      return container.read(provider);
    }))!;
    expect(staleError.hasError && staleError.hasValue, isTrue, reason: 'a failed refresh keeps the earlier data');
    await tester.pumpWidget(page(staleError));
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('DATA 7'), findsOneWidget, reason: 'data stays on screen through a failed refresh');
    expect(find.text(l10n.errorOfflineTitle), findsNothing);

    await tester.pumpWidget(page(AsyncError<int>(offline, StackTrace.empty)));
    await tester.pump(const Duration(milliseconds: 800));
    ApiConnectivity.status.value = NetworkStatus.offline;
    await tester.pump();
    ApiConnectivity.status.value = NetworkStatus.online;
    await tester.pump();
    expect(retries, 1, reason: 'reconnect retries the failed page once');

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('EmptyState action fires and buttons press down', (tester) async {
    usePhoneSurface(tester);
    var taps = 0;
    await tester.pumpWidget(
      app(
        Scaffold(
          body: EmptyState(
            icon: Icons.inbox,
            title: 'Nothing',
            message: 'Nope',
            actionLabel: 'Do it',
            onAction: () => taps++,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final gesture = await tester.startGesture(tester.getCenter(find.text('Do it')));
    await tester.pump(const Duration(milliseconds: 200));
    final scale = tester.widget<AnimatedScale>(
      find.descendant(of: find.byType(PressableScale), matching: find.byType(AnimatedScale)).first,
    );
    expect(scale.scale, lessThan(1), reason: 'button scales down while pressed');
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 400));
    expect(taps, 1);
  });

  test('error classification maps failures to the right view', () {
    expect(networkErrorTypeFor(const NetworkFailure(NetworkFailureKind.timeout)), NetworkErrorType.timeout);
    expect(networkErrorTypeFor(const NetworkFailure(NetworkFailureKind.offline)), NetworkErrorType.noInternet);
    expect(networkErrorTypeFor(StateError('x')), NetworkErrorType.generic);
  });
}
