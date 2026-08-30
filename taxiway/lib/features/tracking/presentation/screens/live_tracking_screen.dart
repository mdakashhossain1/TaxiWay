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
import '../../../../core/widgets/driver_card.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key});

  void _handleTransition(BuildContext context, BookingStatus status) {
    if (!context.mounted) return;
    switch (status) {
      case BookingStatus.driverArrived:
        context.pushReplacement(AppRoutes.driverArrived);
        break;
      case BookingStatus.rideStarted:
      case BookingStatus.rideInProgress:
        context.pushReplacement(AppRoutes.rideInProgress);
        break;
      case BookingStatus.completed:
        context.pushReplacement(AppRoutes.rideCompleted);
        break;
      case BookingStatus.cancelled:
        context.go(AppRoutes.home);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingControllerProvider);
    final driver = ref.watch(currentDriverProvider);
    final vehicle = ref.watch(currentVehicleProvider);

    ref.listen(bookingControllerProvider, (previous, next) {
      if (next != null) _handleTransition(context, next.status);
    });

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('No active booking.')));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, booking.status));

    final progress = 1 - (booking.driverDistanceKm / 2.4).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 6,
                child: RideMapView(
                  pickup: booking.pickup,
                  destination: booking.destination,
                  showDestination: true,
                  showDriver: true,
                  driverProgress: progress,
                  height: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).card,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
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
                              'En route to pickup',
                              style: AppTypography.of(context).h3.copyWith(fontSize: 17, color: AppColors.of(context).navy),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.of(context).primaryBackground,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                '${booking.driverEtaMinutes} min away',
                                style: AppTypography.of(context).caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.of(context).primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your driver is on the way',
                          style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                        ),
                        const SizedBox(height: 14),

                        // Distance Left / Est. Time Left / Arrival Time strip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).surface,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: AppColors.of(context).border),
                          ),
                          child: Row(
                            children: [
                              _Metric(label: 'Distance Left', value: '${booking.driverDistanceKm.toStringAsFixed(1)} km'),
                              Container(width: 1, height: 26, color: AppColors.of(context).border),
                              const SizedBox(width: 12),
                              _Metric(label: 'Est. Time Left', value: '${booking.driverEtaMinutes} min'),
                              Container(width: 1, height: 26, color: AppColors.of(context).border),
                              const SizedBox(width: 12),
                              _Metric(
                                label: 'Arrival Time',
                                value: TimeOfDay.fromDateTime(
                                  DateTime.now().add(Duration(minutes: booking.driverEtaMinutes)),
                                ).format(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        DriverCompactCard(
                          driver: driver,
                          vehicle: vehicle,
                          onCall: () => AppToast.call(context, 'Calling ${driver.name} (+91 98765 00000)...', title: 'Phone Call'),
                          onMessage: () => context.push(
                            AppRoutes.chat,
                            extra: ChatScreenArgs(title: driver.name, conversationId: 'ride_${booking.id}'),
                          ),
                          onViewProfile: () => context.push(AppRoutes.driverProfile),
                        ),
                        const SizedBox(height: 14),

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
                              child: DestructiveButton(
                                label: 'Cancel Ride',
                                onPressed: () {
                                  ref.read(bookingControllerProvider.notifier).cancelBooking();
                                  context.go(AppRoutes.home);
                                },
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

          // Floating Back / Recenter Button
          Positioned(
            top: 48,
            left: 16,
            child: CircleAvatar(
              backgroundColor: AppColors.of(context).card,
              radius: 20,
              child: IconButton(
                onPressed: () => context.go(AppRoutes.home),
                icon: Icon(BootstrapIcons.chevron_left, color: AppColors.of(context).navy, size: 18),
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
          Text(label, style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.of(context).h3.copyWith(fontSize: 14, color: AppColors.of(context).navy, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
