import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/subscription_repository.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/subscription_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/animated_success_check.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/receipt_row.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final snapshot = ref.watch(subscriptionControllerProvider).asData?.value;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.appBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        const AnimatedSuccessCheck(size: 96, iconSize: 48),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            Text(
                              l10n.paymentSuccessfulTitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.of(context).h1.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: colors.navy,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.subscriptionRenewedMessage,
                              textAlign: TextAlign.center,
                              style: AppTypography.of(context).body.copyWith(fontSize: 15, color: colors.bodyText),
                            ),
                          ],
                        )
                            .animate(delay: 450.ms)
                            .fadeIn(duration: 320.ms)
                            .slideY(begin: 0.12, end: 0, duration: 320.ms, curve: Curves.easeOutCubic),
                        const SizedBox(height: 28),
                        if (snapshot != null)
                          _Receipt(snapshot: snapshot)
                              .animate(delay: 650.ms)
                              .fadeIn(duration: 320.ms)
                              .slideY(begin: 0.08, end: 0, duration: 320.ms, curve: Curves.easeOutCubic),
                        const Spacer(flex: 3),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: l10n.doneLabel,
                          onPressed: () => context.go(AppRoutes.subscription),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Receipt extends StatelessWidget {
  final SubscriptionSnapshot snapshot;

  const _Receipt({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final history = snapshot.history;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          ReceiptRow(label: l10n.amountPaidLabel, value: formatRupees(history.lastPayment), emphasized: true),
          ReceiptRow(label: l10n.currentPlan, value: l10n.ridesIncluded(snapshot.plan.totalRides)),
          ReceiptRow(label: l10n.paidOn, value: formatDateWithYear(history.paidOn)),
          ReceiptRow(label: l10n.validUntil, value: formatDateWithYear(history.nextRenewal)),
          ReceiptRow(label: l10n.paymentMethodLabel, value: history.paymentMethod, isLast: true),
        ],
      ),
    );
  }
}
