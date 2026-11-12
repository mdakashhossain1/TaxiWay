import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiwaydriver/core/api/api_client.dart';
import 'package:taxiwaydriver/core/api/network_failure.dart';
import 'package:taxiwaydriver/core/data/ride_repository.dart';
import 'package:taxiwaydriver/core/models/driver_ride.dart';
import 'package:taxiwaydriver/core/router/app_router.dart';
import 'package:taxiwaydriver/core/theme/app_theme.dart';
import 'package:taxiwaydriver/features/rides/presentation/screens/incoming_ride_offer_screen.dart';
import 'package:taxiwaydriver/l10n/generated/app_localizations.dart';
import 'package:toastification/toastification.dart';

class _FailingRides implements RideRepository {
  _FailingRides(this.error);
  final Object error;
  int accepts = 0;

  @override
  Future<DriverRide> acceptRide(String rideId) async {
    accepts++;
    throw error;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) async => null;
}

DriverRide _ride() => DriverRide(
      id: '7',
      dateTime: DateTime(2026, 11, 12, 10),
      pickup: 'A',
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

Future<_FailingRides> _pumpOffer(WidgetTester tester, Object error) async {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final rides = _FailingRides(error);
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => IncomingRideOfferScreen(ride: _ride())),
      GoRoute(path: AppRoutes.dashboard, builder: (_, _) => const Text('DASHBOARD_REACHED')),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [rideRepositoryProvider.overrideWithValue(rides)],
      child: ToastificationWrapper(
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  return rides;
}

Future<void> tapAccept(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Accept Ride'));
  await tester.tap(find.text('Accept Ride'));
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

Future<void> teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 4));
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('accepting while offline keeps the offer on screen so the driver can retry', (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final rides = await _pumpOffer(tester, const NetworkFailure(NetworkFailureKind.offline));

    await tapAccept(tester);

    expect(rides.accepts, 1);
    expect(find.text('DASHBOARD_REACHED'), findsNothing, reason: 'must not abandon the offer');
    expect(find.text('Accept Ride'), findsOneWidget, reason: 'can tap Accept again');
    expect(find.text(l10n.errorOfflineTitle), findsOneWidget);
    expect(find.text(l10n.offerUnavailable), findsNothing, reason: 'offline is not "offer gone"');

    await teardown(tester);
  });

  testWidgets('a real "already taken" answer from the server does leave the offer', (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await _pumpOffer(tester, const ApiException(422, 'This ride is no longer available.'));

    await tapAccept(tester);

    expect(find.text('DASHBOARD_REACHED'), findsOneWidget);
    expect(find.text(l10n.offerUnavailable), findsOneWidget);

    await teardown(tester);
  });

  testWidgets('a server error (5xx) is retryable, not "offer gone"', (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await _pumpOffer(tester, const ApiException(503, 'Service Unavailable'));

    await tapAccept(tester);

    expect(find.text('DASHBOARD_REACHED'), findsNothing);
    expect(find.text(l10n.errorServerTitle), findsOneWidget);

    await teardown(tester);
  });
}
