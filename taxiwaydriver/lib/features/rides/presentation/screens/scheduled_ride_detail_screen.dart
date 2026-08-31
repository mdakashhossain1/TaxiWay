import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/models/driver_ride.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/driver_rides_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// A scheduled ride is open to every eligible driver at once — first to
/// accept wins, so unlike [IncomingRideOfferScreen] there's no per-driver
/// countdown here. Accepting can fail with a 422 if another driver won the
/// race a moment earlier; that message is shown as-is (it's the one failure
/// mode that actually happens in normal use, not an edge case).
class ScheduledRideDetailScreen extends ConsumerStatefulWidget {
  final DriverRide ride;

  const ScheduledRideDetailScreen({super.key, required this.ride});

  @override
  ConsumerState<ScheduledRideDetailScreen> createState() => _ScheduledRideDetailScreenState();
}

class _ScheduledRideDetailScreenState extends ConsumerState<ScheduledRideDetailScreen> {
  bool _acting = false;

  Future<void> _accept() async {
    if (_acting) return;
    setState(() => _acting = true);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(rideActionsProvider.notifier).acceptScheduledRide(widget.ride.id);
      if (!mounted) return;
      AppToast.success(context, l10n.scheduledRideAcceptedToast);
      context.go(AppRoutes.dashboard);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppToast.error(context, e.message, title: l10n.scheduledRideUnavailableTitle);
      context.go(AppRoutes.myRides, extra: 1);
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, l10n.scheduledRideAcceptFailedMessage);
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _decline() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await ref.read(rideActionsProvider.notifier).declineScheduledRide(widget.ride.id);
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context).scheduledRideDeclineFailedMessage);
      setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ride = widget.ride;
    final scheduledAt = ride.scheduledAt;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.scheduledRideDetailTitle, style: AppTypography.of(context).h2)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primaryBorder),
            ),
            child: Row(
              children: [
                Icon(BootstrapIcons.calendar_event, color: AppColors.of(context).primaryDark, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    scheduledAt != null
                        ? '${formatRideDate(scheduledAt)} · ${formatRideTime(scheduledAt)}'
                        : l10n.scheduledRideDetailTitle,
                    style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700, color: AppColors.of(context).primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.openToAllDriversLabel,
            style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText),
          ),
          const SizedBox(height: 20),
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
                Text(
                  '${l10n.expectedFare}: ${formatRupees(ride.fare)}',
                  style: AppTypography.of(context).h3.copyWith(color: AppColors.of(context).primaryDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: l10n.acceptRideLabel,
            icon: BootstrapIcons.check_circle_fill,
            loading: _acting,
            onPressed: _accept,
          ),
          const SizedBox(height: 12),
          DestructiveButton(label: l10n.declineLabel, onPressed: _acting ? null : _decline),
          const SizedBox(height: 24),
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
