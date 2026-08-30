import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/driver_ride.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/driver_rides_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/launch_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class RideDetailsScreen extends ConsumerWidget {
  final DriverRide ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isPaid = ride.paymentStatus == RidePaymentStatus.paid;
    final isCompleted = ride.status == DriverRideStatus.completed;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.rideDetailsTitle, style: AppTypography.of(context).h2)),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
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
                _InfoRow(label: l10n.dateLabel, value: '${formatRideDate(ride.dateTime)} ${ride.dateTime.year}'),
                _InfoRow(label: l10n.timeLabel, value: formatRideTime(ride.dateTime)),
                _InfoRow(label: l10n.customerLabel, value: ride.customerName),
                _InfoRow(label: l10n.pickupLabel, value: ride.pickup),
                _InfoRow(label: l10n.destinationLabel, value: ride.destination),
                _InfoRow(label: l10n.vehicleLabel, value: ride.vehicleCategory),
                _InfoRow(label: l10n.fareLabel, value: formatRupees(ride.fare)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.paymentStatusLabel, style: AppTypography.of(context).caption),
                      StatusBadge(
                        label: isPaid ? l10n.paid : l10n.pending,
                        variant: isPaid ? BadgeVariant.verified : BadgeVariant.pending,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.rideStatusLabel, style: AppTypography.of(context).caption),
                      StatusBadge(
                        label: isCompleted ? l10n.completedTab : l10n.upcomingTab,
                        variant: isCompleted ? BadgeVariant.verified : BadgeVariant.pending,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: l10n.callCustomer,
            icon: BootstrapIcons.telephone_fill,
            onPressed: () {
              launchPhoneCall(ride.customerPhone);
              AppToast.call(context, 'Calling ${ride.customerName}...');
            },
          ),
          const SizedBox(height: 12),
          AppOutlineButton(
            label: 'Message Customer',
            icon: BootstrapIcons.chat_dots_fill,
            onPressed: () => context.push(
              AppRoutes.chat,
              extra: ChatScreenArgs(title: ride.customerName, conversationId: 'ride_${ride.id}'),
            ),
          ),
          const SizedBox(height: 12),
          AppOutlineButton(
            label: l10n.openMap,
            icon: BootstrapIcons.map_fill,
            onPressed: () => launchMapsDirections(destLat: ride.destinationLat, destLng: ride.destinationLng),
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 12),
            SecondaryButton(
              label: l10n.markCompleted,
              icon: BootstrapIcons.check_circle_fill,
              onPressed: () async {
                try {
                  await ref.read(rideActionsProvider.notifier).markCompleted(ride.id);
                  if (!context.mounted) return;
                  AppToast.success(context, l10n.markedCompletedToast);
                  context.pop();
                } catch (_) {
                  if (!context.mounted) return;
                  AppToast.error(context, "Couldn't mark this ride completed. Please try again.");
                }
              },
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.of(context).caption),
          Flexible(
            child: Text(
              value,
              style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
