import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiwaydriver/core/data/subscription_repository.dart';
import 'package:taxiwaydriver/core/models/subscription_plan.dart';
import 'package:taxiwaydriver/core/state/subscription_controller.dart';
import 'package:taxiwaydriver/core/theme/app_theme.dart';
import 'package:taxiwaydriver/features/subscription/presentation/screens/payment_success_screen.dart';
import 'package:taxiwaydriver/l10n/generated/app_localizations.dart';

class _FakeSubscription extends SubscriptionController {
  @override
  Future<SubscriptionSnapshot> build() async => SubscriptionSnapshot(
        plan: SubscriptionPlan(id: 1, pricePerMonth: 499, totalRides: 120, usedRides: 0, renewalDate: DateTime(2026, 12, 12)),
        summary: const PaymentSummary(thisMonthCollected: 0, completedRides: 0, todayCollected: 0, pendingPayment: 0),
        history: PaymentHistoryEntry(
          lastPayment: 499,
          paidOn: DateTime(2026, 11, 12),
          nextRenewal: DateTime(2026, 12, 12),
          paymentMethod: 'UPI',
        ),
      );
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  for (final locale in const [Locale('en'), Locale('hi'), Locale('bn')]) {
    for (final size in const [Size(320, 568), Size(360, 740)]) {
      for (final scale in const [1.0, 1.3]) {
        testWidgets('payment success ${locale.languageCode} ${size.width.toInt()}x${size.height.toInt()} x$scale', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            ProviderScope(
              overrides: [subscriptionControllerProvider.overrideWith(_FakeSubscription.new)],
              child: MaterialApp(
                theme: AppTheme.light,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: const PaymentSuccessScreen(),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(seconds: 2));

          expect(find.textContaining('₹499'), findsOneWidget);
        });
      }
    }
  }
}
