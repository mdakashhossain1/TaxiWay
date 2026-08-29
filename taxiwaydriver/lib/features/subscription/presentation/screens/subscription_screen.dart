import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/subscription_repository.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/subscription_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/driver_bottom_nav.dart';
import '../../../../core/widgets/page_state_builder.dart';
import '../../../../core/widgets/subscription_metric_card.dart';
import '../../../../core/widgets/usage_progress_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  void _goToTab(BuildContext context, DriverNavTab tab) {
    context.go(tab == DriverNavTab.rides ? AppRoutes.myRides : AppRoutes.subscription);
  }

  String _formatNullableDate(DateTime? date) => date == null ? '—' : '${formatRideDate(date)} ${date.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(subscriptionControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        title: Text(l10n.subscriptionTitle, style: AppTypography.h2),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(BootstrapIcons.house_fill, color: AppColors.navy),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
      ),
      bottomNavigationBar: DriverBottomNav(selected: DriverNavTab.subscription, onSelect: (tab) => _goToTab(context, tab)),
      body: SafeArea(
        child: PageStateBuilder<SubscriptionSnapshot>(
          asyncValue: snapshotAsync,
          shimmer: const DashboardShimmer(),
          onRetry: () async => ref.invalidate(subscriptionControllerProvider),
          builder: (context, snapshot) {
            final plan = snapshot.plan;
            final summary = snapshot.summary;
            final history = snapshot.history;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan card.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.currentPlan, style: AppTypography.label.copyWith(color: AppColors.primaryDark)),
                        const SizedBox(height: 4),
                        Text('${formatRupees(plan.pricePerMonth)} / month', style: AppTypography.priceLarge),
                        Text(l10n.ridesIncluded(plan.totalRides), style: AppTypography.body),
                        const SizedBox(height: 14),
                        UsageProgressBar(fraction: plan.usageFraction),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${plan.usedRides}/${plan.totalRides} ${l10n.ridesUsed}', style: AppTypography.body),
                            Text('${plan.remainingRides} ${l10n.ridesRemaining}', style: AppTypography.body),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${l10n.validUntil}: ${_formatNullableDate(plan.renewalDate)}', style: AppTypography.caption),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2x2 payment summary grid.
                  Row(
                    children: [
                      Expanded(child: SubscriptionMetricCard(value: formatRupees(summary.thisMonthCollected), label: l10n.thisMonthCollected)),
                      const SizedBox(width: 12),
                      Expanded(child: SubscriptionMetricCard(value: '${summary.completedRides}', label: l10n.completedRidesLabel)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: SubscriptionMetricCard(value: formatRupees(summary.todayCollected), label: l10n.todayCollected)),
                      const SizedBox(width: 12),
                      Expanded(child: SubscriptionMetricCard(value: formatRupees(summary.pendingPayment), label: l10n.pendingPaymentLabel)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _HistoryRow(label: l10n.lastPayment, value: formatRupees(history.lastPayment)),
                        _HistoryRow(label: l10n.paidOn, value: _formatNullableDate(history.paidOn)),
                        _HistoryRow(label: l10n.nextRenewal, value: _formatNullableDate(history.nextRenewal)),
                        _HistoryRow(label: l10n.paymentMethodLabel, value: history.paymentMethod, isLast: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: l10n.renewSubscription,
                    onPressed: () async {
                      try {
                        await ref.read(subscriptionControllerProvider.notifier).renewSubscription();
                        if (!context.mounted) return;
                        AppToast.success(context, l10n.renewedToast);
                      } catch (_) {
                        if (!context.mounted) return;
                        AppToast.error(context, "Couldn't renew right now. Please try again.");
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _HistoryRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.caption),
              Text(value, style: AppTypography.label.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
