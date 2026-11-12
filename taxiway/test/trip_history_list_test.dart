import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiway/core/models/trip_history_item.dart';
import 'package:taxiway/core/providers.dart';
import 'package:taxiway/core/state/trip_history_controller.dart';
import 'package:taxiway/core/theme/app_theme.dart';
import 'package:taxiway/core/widgets/trip_card.dart';
import 'package:taxiway/features/trips/presentation/screens/trip_history_screen.dart';
import 'package:taxiway/l10n/generated/app_localizations.dart';

Map<String, dynamic> _trip(int id) => {
      'id': id,
      'vehicle_category_id': 3,
      'pickup_address': 'A',
      'pickup_lat': '25.598',
      'pickup_lng': '85.128',
      'destination_address': 'B',
      'destination_lat': '25.61',
      'destination_lng': '85.14',
      'distance_km': '3.2',
      'eta_minutes': 9,
      'base_fare': '100',
      'distance_charge': '38.4',
      'time_charge': '0',
      'status': 'completed',
      'created_at': DateTime(2026, 11, 12).toUtc().toIso8601String(),
      'payment_method': 'cash',
      'payment_status': 'paid',
      'type': 'instant',
      'driver': null,
      'vehicle': null,
      'category': {'id': 3, 'name': 'Sedan', 'seats': 4, 'ac': true, 'base_fare': '100', 'per_km_rate': '12'},
    };

class _FakeTrips extends TripHistoryController {
  @override
  Future<List<TripHistoryItem>> build() async => [for (var i = 1; i <= 60; i++) TripHistoryItem.fromJson(_trip(i))];
}

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

  testWidgets('trips far down a long history appear at once instead of waiting for a staggered entrance', (tester) async {
    ignoreFontOverflow();
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [tripHistoryControllerProvider.overrideWith(_FakeTrips.new)],
        child: MaterialApp(
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const TripHistoryScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final list = find.byType(ListView).first;
    expect(find.byType(TripCard), findsWidgets);
    expect(find.descendant(of: find.byType(Animate), matching: find.byType(TripCard)), findsWidgets, reason: 'the first items still animate in');
    for (var i = 0; i < 6; i++) {
      await tester.drag(list, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(TripCard), findsWidgets);
    final delayedEntrances = find.descendant(of: find.byType(Animate), matching: find.byType(TripCard));
    expect(delayedEntrances, findsNothing, reason: 'items beyond the first few must not carry an entrance delay');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
