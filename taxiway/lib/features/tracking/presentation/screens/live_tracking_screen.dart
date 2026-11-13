import '../../../../core/theme/app_icons.dart';
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
import '../../../../core/utils/launch_utils.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/sheet_action_button.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).noActiveBookingLabel)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, booking.status));

    final progress = 1 - (booking.driverDistanceKm / 2.4).clamp(0.0, 1.0);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RideMapView(
                  pickup: booking.pickup,
                  destination: booking.destination,
                  showDestination: true,
                  showDriver: true,
                  driverProgress: progress,
                  driverPosition: driverPositionOf(booking),
                  height: double.infinity,
                  borderRadius: BorderRadius.zero,
                  enableExpand: false,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
                  boxShadow: AppShadows.sheet,
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(color: colors.borderStrong, borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).meetAtPickupIn(booking.driverEtaMinutes),
                                    style: type.h2.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    AppLocalizations.of(context).kmAway(booking.driverDistanceKm.toStringAsFixed(1)),
                                    style: type.body.copyWith(color: colors.secondaryText),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(AppRadius.small),
                              ),
                              child: Text(
                                vehicle.registrationNumber,
                                style: type.label.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(height: 1, color: colors.border),
                        const SizedBox(height: 14),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.push(AppRoutes.driverProfile),
                          child: Row(
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                                child: driver.photoUrl.isEmpty
                                    ? Icon(AppIcons.person_fill, color: colors.mutedText, size: 26)
                                    : AppNetworkImage(
                                        url: driver.photoUrl,
                                        fit: BoxFit.cover,
                                        fallback: Icon(AppIcons.person_fill, color: colors.mutedText, size: 26),
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            driver.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: type.h3.copyWith(fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(AppIcons.star_fill, size: 14, color: colors.navy),
                                        const SizedBox(width: 2),
                                        Text(driver.rating.toStringAsFixed(1), style: type.label.copyWith(fontSize: 14)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(vehicle.model, style: type.caption.copyWith(color: colors.secondaryText)),
                                  ],
                                ),
                              ),
                              Icon(AppIcons.chevron_right, size: 16, color: colors.mutedText),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => context.push(
                                  AppRoutes.chat,
                                  extra: ChatScreenArgs(title: driver.name, conversationId: 'ride_${booking.id}'),
                                ),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(AppRadius.pill)),
                                  child: Row(
                                    children: [
                                      Icon(AppIcons.chat_dots, size: 18, color: colors.navy),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context).messagePerson(driver.name.split(' ').first),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: type.body.copyWith(color: colors.secondaryText, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleIconButton(
                              icon: AppIcons.telephone_fill,
                              background: colors.surface,
                              foreground: colors.navy,
                              onPressed: () => launchPhoneCall(driver.phone),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SheetActionButton(
                                icon: AppIcons.share_fill,
                                label: AppLocalizations.of(context).shareTrip,
                                onTap: () => AppToast.success(context, AppLocalizations.of(context).tripLinkCopiedToast, title: AppLocalizations.of(context).linkShared),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SheetActionButton(
                                icon: AppIcons.x_circle_fill,
                                label: AppLocalizations.of(context).cancelRideAction,
                                destructive: true,
                                onTap: () {
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: PressableScale(
                pressedScale: 0.92,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.go(AppRoutes.home),
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(color: colors.card, shape: BoxShape.circle, boxShadow: AppShadows.elevated),
                    child: Icon(AppIcons.arrow_left, color: colors.navy, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
