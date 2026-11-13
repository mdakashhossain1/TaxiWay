import 'dart:async';

import '../../../../core/theme/app_icons.dart';
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
  static const _offerWindowSeconds = 20;

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
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final offerGone = error is ApiException && error.statusCode < 500;
      if (offerGone) {
        AppToast.error(context, l10n.offerUnavailable);
        context.go(AppRoutes.dashboard);
      } else {
        AppToast.failure(context, error, fallback: l10n.offerAcceptFailed);
      }
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
    } catch (error) {
      if (!mounted) return;
      AppToast.failure(context, error, fallback: AppLocalizations.of(context).offerDeclineFailed);
      setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final expired = _secondsLeft <= 0;
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    return AppScaffold(
      appBar: AppBar(title: Text('New Ride Offer', style: type.h2), automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      width: 104,
                      height: 104,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(end: expired ? 0 : (_secondsLeft / _offerWindowSeconds).clamp(0.0, 1.0)),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.linear,
                              builder: (context, value, _) => CircularProgressIndicator(
                                value: value,
                                strokeWidth: 6,
                                strokeCap: StrokeCap.round,
                                backgroundColor: colors.surface,
                                color: _secondsLeft <= 5 ? colors.error : colors.primary,
                              ),
                            ),
                          ),
                          Text('${_secondsLeft}s', style: type.h1.copyWith(color: expired ? colors.mutedText : colors.navy)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(child: Text(formatRupees(ride.fare), style: type.display.copyWith(fontSize: 44, height: 1.1))),
                  const SizedBox(height: 4),
                  Center(child: Text('${ride.vehicleCategory} · ${ride.customerName}', style: type.body)),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(AppRadius.card)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RoutePoint(isPickup: true, text: ride.pickup),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: SizedBox(height: 16, child: VerticalDivider(width: 1, thickness: 1.5, color: colors.borderStrong)),
                        ),
                        _RoutePoint(isPickup: false, text: ride.destination),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (expired)
            Center(
              child: Text('This offer has expired.', style: type.body.copyWith(color: colors.mutedText)),
            )
          else ...[
            PrimaryButton(label: 'Accept Ride', icon: AppIcons.check_circle_fill, loading: _acting, onPressed: _accept),
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
  final bool isPickup;
  final String text;

  const _RoutePoint({required this.isPickup, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: isPickup ? colors.navy : colors.accent,
            shape: isPickup ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isPickup ? null : BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTypography.of(context).body.copyWith(fontWeight: FontWeight.w600, color: colors.navy),
          ),
        ),
      ],
    );
  }
}
