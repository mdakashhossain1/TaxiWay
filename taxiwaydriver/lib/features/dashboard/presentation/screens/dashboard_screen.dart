import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/driver_ride.dart';
import '../../../../core/router/app_router.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../../core/state/auth_controller.dart';
import '../../../../core/state/driver_rides_controller.dart';
import '../../../../core/state/subscription_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/launch_utils.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/driver_bottom_nav.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/taxiway_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/usage_progress_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _goToTab(BuildContext context, DriverNavTab tab) {
    context.go(tab == DriverNavTab.rides ? AppRoutes.myRides : AppRoutes.subscription);
  }

  void _showLogoutConfirm(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(authControllerProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            child: Text(l10n.logout, style: TextStyle(color: AppColors.of(context).error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(authControllerProvider).driver;
    final subscriptionAsync = ref.watch(subscriptionControllerProvider);
    final nextRideAsync = ref.watch(nextRideProvider);
    final pendingOfferAsync = ref.watch(pendingOfferProvider);
    final scheduledRidesAsync = ref.watch(scheduledRidesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      bottomNavigationBar: DriverBottomNav(selected: null, onSelect: (tab) => _goToTab(context, tab)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaxiwayHeader(
                onProfileTap: () => _showLogoutConfirm(context, ref),
                onSupportTap: () => context.push(AppRoutes.chat, extra: const ChatScreenArgs(title: 'Support')),
              ),
              const SizedBox(height: 12),

              // Identity row: avatar, name, verified badge.
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: AppColors.of(context).surface, shape: BoxShape.circle),
                    child: Icon(BootstrapIcons.person_fill, color: AppColors.of(context).mutedText, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver?.name ?? '', style: AppTypography.of(context).h2),
                        const SizedBox(height: 4),
                        StatusBadge(label: l10n.verifiedDriver, variant: BadgeVariant.verified, icon: BootstrapIcons.check_circle_fill),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subscription summary card.
              subscriptionAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => ErrorState(onRetry: () => ref.invalidate(subscriptionControllerProvider)),
                data: (snapshot) {
                  final plan = snapshot.plan;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.of(context).primaryBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.currentPlan, style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).primaryDark)),
                        const SizedBox(height: 4),
                        Text('${formatRupees(plan.pricePerMonth)} / month', style: AppTypography.of(context).priceLarge),
                        Text(l10n.ridesIncluded(plan.totalRides), style: AppTypography.of(context).body),
                        const SizedBox(height: 14),
                        UsageProgressBar(fraction: plan.usageFraction),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${plan.usedRides}', style: AppTypography.of(context).priceLarge.copyWith(color: AppColors.of(context).primaryDark)),
                                Text(l10n.ridesUsed, style: AppTypography.of(context).caption),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${plan.remainingRides}', style: AppTypography.of(context).priceLarge.copyWith(color: AppColors.of(context).primaryDark)),
                                Text(l10n.ridesRemaining, style: AppTypography.of(context).caption),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${l10n.renewalDateLabel}: ${formatRideDate(plan.renewalDate)} ${plan.renewalDate.year}',
                          style: AppTypography.of(context).caption,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              scheduledRidesAsync.maybeWhen(
                data: (rides) => rides.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _ScheduledRidesBanner(count: rides.length),
                      ),
                orElse: () => const SizedBox.shrink(),
              ),

              pendingOfferAsync.maybeWhen(
                data: (offer) => offer == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _PendingOfferBanner(ride: offer),
                      ),
                orElse: () => const SizedBox.shrink(),
              ),

              Text(l10n.nextRide, style: AppTypography.of(context).h3),
              const SizedBox(height: 10),

              nextRideAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => ErrorState(onRetry: () => ref.invalidate(nextRideProvider)),
                data: (nextRide) => nextRide == null
                    ? EmptyState(icon: BootstrapIcons.calendar_x, title: l10n.noUpcomingRides, message: '')
                    : _NextRideCard(ride: nextRide, l10n: l10n),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Surfaces an outstanding ride offer if the app was reopened after a push
/// was missed (permission denied, app killed before it arrived, etc.) —
/// `pendingOfferProvider` is the same authoritative source the push handler
/// uses, just polled on screen entry instead of pushed.
/// Points at open scheduled-ride broadcasts matching this driver's category
/// — deep-links straight into MyRidesScreen's Scheduled tab (index 1).
class _ScheduledRidesBanner extends StatelessWidget {
  final int count;

  const _ScheduledRidesBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border),
      ),
      child: Row(
        children: [
          Icon(BootstrapIcons.calendar_event, color: AppColors.of(context).primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.scheduledRidesAvailableTitle, style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700)),
                Text(l10n.scheduledRidesAvailableCount(count), style: AppTypography.of(context).caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.myRides, extra: 1),
            child: Text(l10n.viewAllLabel),
          ),
        ],
      ),
    );
  }
}

class _PendingOfferBanner extends StatelessWidget {
  final DriverRide ride;

  const _PendingOfferBanner({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).primaryBorder),
      ),
      child: Row(
        children: [
          Icon(BootstrapIcons.bell_fill, color: AppColors.of(context).primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New ride offer waiting', style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700)),
                Text(ride.pickup, style: AppTypography.of(context).caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.rideOffer, extra: ride),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

class _NextRideCard extends StatelessWidget {
  final DriverRide ride;
  final AppLocalizations l10n;

  const _NextRideCard({required this.ride, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${formatRideDate(ride.dateTime)} · ${formatRideTime(ride.dateTime)}', style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _RoutePoint(color: AppColors.of(context).success, text: ride.pickup),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: SizedBox(height: 14, child: VerticalDivider(width: 1, thickness: 1.5, color: AppColors.of(context).borderStrong)),
          ),
          _RoutePoint(color: AppColors.of(context).primary, text: ride.destination),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.of(context).border),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.customerLabel}: ${ride.customerName}', style: AppTypography.of(context).body),
              Text(ride.vehicleCategory, style: AppTypography.of(context).body),
            ],
          ),
          const SizedBox(height: 6),
          Text('${l10n.expectedFare}: ${formatRupees(ride.fare)}', style: AppTypography.of(context).h3.copyWith(color: AppColors.of(context).primaryDark)),
          const SizedBox(height: 16),
          PrimaryButton(
            label: l10n.viewRideDetails,
            onPressed: () => context.push(AppRoutes.rideDetails, extra: ride),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppOutlineButton(
                  label: l10n.callCustomer,
                  icon: BootstrapIcons.telephone_fill,
                  onPressed: () {
                    launchPhoneCall(ride.customerPhone);
                    AppToast.call(context, 'Calling ${ride.customerName}...');
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 44,
                height: 52,
                child: CircleIconButton(
                  icon: BootstrapIcons.chat_dots_fill,
                  onPressed: () => context.push(
                    AppRoutes.chat,
                    extra: ChatScreenArgs(title: ride.customerName, conversationId: 'ride_${ride.id}'),
                  ),
                  background: AppColors.of(context).surface,
                  foreground: AppColors.of(context).navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final Color color;
  final String text;

  const _RoutePoint({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTypography.of(context).body.copyWith(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
