import 'dart:async';
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
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';

/// Shown when a new ride offer arrives (push tap, or found via
/// `pendingOfferProvider` on app open). A 20-second, server-enforced window
/// (`Booking.offer_expires_at`) — this countdown mirrors it for UX; the
/// backend is the actual authority, so a stale accept still gets a clean 422
/// rather than silently succeeding.
class IncomingRideOfferScreen extends ConsumerStatefulWidget {
  final DriverRide ride;

  const IncomingRideOfferScreen({super.key, required this.ride});

  @override
  ConsumerState<IncomingRideOfferScreen> createState() => _IncomingRideOfferScreenState();
}

class _IncomingRideOfferScreenState extends ConsumerState<IncomingRideOfferScreen> {
  Timer? _timer;
  int _secondsLeft = 0;
  bool _acting = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = _remainingSeconds();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = _remainingSeconds();
      if (!mounted) return;
      setState(() => _secondsLeft = left);
      if (left <= 0) t.cancel();
    });
  }

  int _remainingSeconds() {
    final expiresAt = widget.ride.offerExpiresAt;
    if (expiresAt == null) return 0;
    return expiresAt.difference(DateTime.now()).inSeconds.clamp(0, 999);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _accept() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await ref.read(rideActionsProvider.notifier).acceptRide(widget.ride.id);
      if (!mounted) return;
      AppToast.success(context, 'Ride confirmed! Head to pickup.', title: 'Accepted');
      context.go(AppRoutes.dashboard);
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, 'This offer is no longer available.', title: 'Too Late');
      context.go(AppRoutes.dashboard);
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _reject() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await ref.read(rideActionsProvider.notifier).rejectRide(widget.ride.id);
      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, "Couldn't decline this offer. Please try again.");
      setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final expired = _secondsLeft <= 0;

    return AppScaffold(
      appBar: AppBar(title: Text('New Ride Offer', style: AppTypography.of(context).h2), automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: expired ? AppColors.of(context).surface : AppColors.of(context).primaryBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  expired ? '0s' : '${_secondsLeft}s',
                  style: AppTypography.of(context).h2.copyWith(color: expired ? AppColors.of(context).mutedText : AppColors.of(context).primaryDark),
                ),
              ),
            ),
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
                    Text('Customer: ${ride.customerName}', style: AppTypography.of(context).body),
                    Text(ride.vehicleCategory, style: AppTypography.of(context).body),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Fare: ${formatRupees(ride.fare)}', style: AppTypography.of(context).h3.copyWith(color: AppColors.of(context).primaryDark)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          if (expired)
            Center(
              child: Text(
                'This offer has expired.',
                style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText),
              ),
            )
          else ...[
            PrimaryButton(
              label: 'Accept Ride',
              icon: BootstrapIcons.check_circle_fill,
              loading: _acting,
              onPressed: _accept,
            ),
            const SizedBox(height: 12),
            DestructiveButton(label: 'Decline', onPressed: _acting ? null : _reject),
          ],
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
