import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/booking.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/ride_map_view.dart';

class RideInProgressScreen extends ConsumerWidget {
  const RideInProgressScreen({super.key});

  void _handleTransition(BuildContext context, BookingStatus status) {
    if (!context.mounted) return;
    if (status == BookingStatus.completed) {
      context.pushReplacement(AppRoutes.rideCompleted);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingControllerProvider);

    ref.listen(bookingControllerProvider, (previous, next) {
      if (next != null) _handleTransition(context, next.status);
    });

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('No active booking.')));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, booking.status));

    final remainingKm = booking.distanceKm * (1 - booking.routeProgress);
    final remainingMin = (booking.etaMinutes * (1 - booking.routeProgress)).round().clamp(1, 999);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: RideMapView(
              pickup: booking.pickup,
              destination: booking.destination,
              showDestination: true,
              showDriver: true,
              driverPhase: MapDriverPhase.headingToDestination,
              driverProgress: booking.routeProgress,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
                boxShadow: AppShadows.elevated,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ride in progress',
                          style: AppTypography.h3.copyWith(fontSize: 18, color: AppColors.navy),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successBackground,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'On Track',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Heading to ${booking.destination.shortName}',
                      style: AppTypography.caption.copyWith(color: AppColors.bodyText),
                    ),
                    const SizedBox(height: 14),

                    // Metrics Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          _Metric(label: 'Distance Left', value: '${remainingKm.toStringAsFixed(1)} km'),
                          Container(width: 1, height: 26, color: AppColors.border),
                          const SizedBox(width: 12),
                          _Metric(label: 'Time Left', value: '$remainingMin min'),
                          Container(width: 1, height: 26, color: AppColors.border),
                          const SizedBox(width: 12),
                          _Metric(
                            label: 'Arrival',
                            value: TimeOfDay.fromDateTime(
                              DateTime.now().add(Duration(minutes: remainingMin)),
                            ).format(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Progress Indicator Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: booking.routeProgress.clamp(0.05, 1.0),
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: AppOutlineButton(
                            label: 'Share Trip',
                            icon: BootstrapIcons.share_fill,
                            onPressed: () => AppToast.success(context, 'Live trip tracking link copied to clipboard!', title: 'Link Shared'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => AppToast.error(
                              context,
                              'Emergency SOS alert triggered! 24x7 support & police alerted.',
                              title: 'SOS Alert Sent',
                            ),
                            icon: const Icon(BootstrapIcons.shield_exclamation, color: AppColors.error, size: 16),
                            label: Text(
                              'SOS',
                              style: AppTypography.button.copyWith(color: AppColors.error, fontSize: 13),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.error, width: 1.2),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.button),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.mutedText, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.h3.copyWith(fontSize: 14, color: AppColors.navy, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
