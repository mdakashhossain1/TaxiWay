import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/trip_history_item.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/animated_success_check.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../l10n/generated/app_localizations.dart';

class RideCompletedScreen extends ConsumerWidget {
  const RideCompletedScreen({super.key});

  void _finish(BuildContext context, WidgetRef ref) {
    ref.read(tripHistoryControllerProvider.notifier).refresh();
    ref.read(bookingControllerProvider.notifier).clear();
    ref.read(bookingDraftControllerProvider.notifier).reset();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final booking = ref.watch(bookingControllerProvider);
    final driver = ref.watch(currentDriverProvider);
    final vehicle = ref.watch(currentVehicleProvider);

    if (booking == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).noCompletedRideFound)));
    }

    final firstName = driver.name.split(' ').first;

    return Scaffold(
      backgroundColor: colors.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AnimatedSuccessCheck(size: 40, iconSize: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.rideCompleteTitle,
                            style: type.h1.copyWith(fontWeight: FontWeight.w800),
                          ).animate().fadeIn(delay: 150.ms, duration: 300.ms).slideX(begin: 0.05, end: 0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            formatRupees(booking.fare.total),
                            style: type.display.copyWith(fontSize: 56, height: 1.05),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(AppRadius.pill)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(AppIcons.cash_stack, size: 16, color: colors.navy),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.paidWithLabel(booking.paymentMethod.toUpperCase()),
                                  style: type.label.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 350.ms).scale(
                          begin: const Offset(0.94, 0.94),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(AppRadius.card)),
                      child: Column(
                        children: [
                          Text(
                            l10n.rateYourRideWith(firstName),
                            textAlign: TextAlign.center,
                            style: type.h3.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          InteractiveRatingStars(
                            value: 0,
                            onChanged: (rating) => context.push(AppRoutes.ratingReview, extra: rating),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 300.ms).slideY(begin: 0.08, end: 0),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RouteStop(isPickup: true, text: booking.pickup.shortName),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: SizedBox(
                              height: 16,
                              child: VerticalDivider(width: 1, thickness: 1.5, color: colors.borderStrong),
                            ),
                          ),
                          _RouteStop(isPickup: false, text: booking.destination.shortName),
                          const SizedBox(height: 16),
                          Divider(height: 1, color: colors.border),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _Stat(value: '${booking.distanceKm.toStringAsFixed(1)} km'),
                              _Stat(value: '${booking.etaMinutes} min'),
                              _Stat(value: vehicle.registrationNumber),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${driver.name} · ${vehicle.model}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: type.caption.copyWith(color: colors.secondaryText),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms, duration: 300.ms).slideY(begin: 0.08, end: 0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(label: l10n.doneLabel, onPressed: () => _finish(context, ref)),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.tripDetails, extra: TripHistoryItem(booking: booking)),
                    child: Text(
                      l10n.viewReceiptLabel,
                      style: type.label.copyWith(color: colors.navy, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteStop extends StatelessWidget {
  final bool isPickup;
  final String text;

  const _RouteStop({required this.isPickup, required this.text});

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
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.of(context).bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;

  const _Stat({required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
