import '../../../../core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/booking.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/driver_card.dart';
import '../../../../l10n/generated/app_localizations.dart';

class DriverArrivedScreen extends ConsumerWidget {
  const DriverArrivedScreen({super.key});

  void _handleTransition(BuildContext context, BookingStatus status) {
    if (!context.mounted) return;
    if (status == BookingStatus.rideStarted || status == BookingStatus.rideInProgress) {
      context.pushReplacement(AppRoutes.rideInProgress);
    } else if (status == BookingStatus.completed) {
      context.pushReplacement(AppRoutes.rideCompleted);
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
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).noActiveBookingLabel)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, booking.status));

    return AppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).driverArrivedTitle, style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Arrived Icon & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.of(context).successBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(AppIcons.geo_alt_fill, color: AppColors.of(context).success, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).yourDriverHasArrived,
                      style: AppTypography.of(context).h2.copyWith(fontSize: 20, color: AppColors.of(context).navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).waitingAtPlace(booking.pickup.shortName),
                      style: AppTypography.of(context).body.copyWith(fontSize: 14, color: AppColors.of(context).bodyText),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),

          const SizedBox(height: 18),

          // Start Ride OTP Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).startRideOtp,
                      style: AppTypography.of(context).caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.of(context).primaryDark,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).shareWithDriverToStart,
                      style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.of(context).primary),
                  ),
                  child: Text(
                    '1234',
                    style: AppTypography.of(context).h1.copyWith(
                      fontSize: 22,
                      letterSpacing: 4,
                      color: AppColors.of(context).primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Driver Compact Card
          DriverCompactCard(
            driver: driver,
            vehicle: vehicle,
            onCall: () => AppToast.call(context, AppLocalizations.of(context).callingPerson(driver.name), title: AppLocalizations.of(context).phoneCallTitle),
            onMessage: () => context.push(
              AppRoutes.chat,
              extra: ChatScreenArgs(title: driver.name, conversationId: 'ride_${booking.id}'),
            ),
            onViewProfile: () => context.push(AppRoutes.driverProfile),
          ),

          const SizedBox(height: 14),

          // Safety Hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.of(context).surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Row(
              children: [
                Icon(AppIcons.shield_check, size: 18, color: AppColors.of(context).primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).checkVehicleNumberBeforeBoarding,
                    style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: AppOutlineButton(
                  label: AppLocalizations.of(context).viewVehicle,
                  icon: AppIcons.car_front,
                  onPressed: () => context.push(AppRoutes.vehicleGallery),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: AppLocalizations.of(context).callDriver,
                  icon: AppIcons.telephone_fill,
                  onPressed: () => AppToast.call(context, AppLocalizations.of(context).callingPerson(driver.name), title: AppLocalizations.of(context).phoneCallTitle),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
