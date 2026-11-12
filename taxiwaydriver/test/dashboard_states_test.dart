import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiwaydriver/core/api/network_failure.dart';
import 'package:taxiwaydriver/core/data/subscription_repository.dart';
import 'package:taxiwaydriver/core/models/driver_ride.dart';
import 'package:taxiwaydriver/core/models/subscription_plan.dart';
import 'package:taxiwaydriver/core/state/driver_rides_controller.dart';
import 'package:taxiwaydriver/core/state/subscription_controller.dart';
import 'package:taxiwaydriver/core/theme/app_theme.dart';
import 'package:taxiwaydriver/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:taxiwaydriver/l10n/generated/app_localizations.dart';

class _FakeSubscription extends SubscriptionController {
  @override
  Future<SubscriptionSnapshot> build() async => SubscriptionSnapshot(
        plan: SubscriptionPlan(id: 1, pricePerMonth: 499, totalRides: 120, usedRides: 10, renewalDate: DateTime(2026, 12, 12)),
        summary: const PaymentSummary(thisMonthCollected: 0, completedRides: 0, todayCollected: 0, pendingPayment: 0),
        history: PaymentHistoryEntry(
          lastPayment: 499,
          paidOn: DateTime(2026, 11, 12),
          nextRenewal: DateTime(2026, 12, 12),
          paymentMethod: 'UPI',
        ),
      );
}

DriverRide _offer() => DriverRide(
      id: '7',
      dateTime: DateTime(2026, 11, 12, 10),
      pickup: 'Mithapur',
      pickupLat: 25.598,
      pickupLng: 85.128,
      destination: 'B',
      destinationLat: 25.61,
      destinationLng: 85.14,
      customerName: 'C',
      customerPhone: '1',
      vehicleCategory: '4',
      fare: 180,
      paymentStatus: RidePaymentStatus.pending,
      status: DriverRideStatus.offered,
      offerExpiresAt: DateTime.now().add(const Duration(seconds: 20)),
    );

// The test font draws every glyph a full em wide, so rows that fit on a device overflow here.
void ignoreFontOverflow() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('a failed pending-offer check is visible and retryable, then shows the offer', (tester) async {
    ignoreFontOverflow();
    tester.view.physicalSize = const Size(411, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    var failing = true;

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          subscriptionControllerProvider.overrideWith(_FakeSubscription.new),
          nextRideProvider.overrideWith((ref) async => null),
          scheduledRidesProvider.overrideWith((ref) async => <DriverRide>[]),
          pendingOfferProvider.overrideWith((ref) async {
            if (failing) throw const NetworkFailure(NetworkFailureKind.offline);
            return _offer();
          }),
        ],
        child: ThemeProvider(
          initTheme: AppTheme.light,
          builder: (context, theme) => MaterialApp(
            theme: theme,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => ThemeSwitchingArea(child: child!),
            home: const DashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(l10n.offerCheckFailed), findsOneWidget, reason: 'a missed offer check must not be silent');
    expect(find.text('New ride offer waiting'), findsNothing);

    failing = false;
    await tester.ensureVisible(find.text(l10n.tryAgainLabel));
    await tester.tap(find.text(l10n.tryAgainLabel));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('New ride offer waiting'), findsOneWidget);
    expect(find.text(l10n.offerCheckFailed), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the scheduled-rides banner lays out with its button', (tester) async {
    ignoreFontOverflow();
    tester.view.physicalSize = const Size(411, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          subscriptionControllerProvider.overrideWith(_FakeSubscription.new),
          nextRideProvider.overrideWith((ref) async => null),
          pendingOfferProvider.overrideWith((ref) async => null),
          scheduledRidesProvider.overrideWith((ref) async => [_offer()]),
        ],
        child: ThemeProvider(
          initTheme: AppTheme.light,
          builder: (context, theme) => MaterialApp(
            theme: theme,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => ThemeSwitchingArea(child: child!),
            home: const DashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(l10n.viewAllLabel), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
