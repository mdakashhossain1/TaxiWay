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
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/sheet_action_button.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).noActiveBookingLabel)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, booking.status));

    final remainingKm = booking.distanceKm * (1 - booking.routeProgress);
    final remainingMin = (booking.etaMinutes * (1 - booking.routeProgress)).round().clamp(1, 999);

    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final arrival = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: remainingMin))).format(context);

    return Scaffold(
      backgroundColor: colors.appBackground,
      body: Column(
        children: [
          Expanded(
            child: RideMapView(
              pickup: booking.pickup,
              destination: booking.destination,
              showDestination: true,
              showDriver: true,
              driverPhase: MapDriverPhase.headingToDestination,
              driverProgress: booking.routeProgress,
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
                    Text(
                      AppLocalizations.of(context).headingToPlace(booking.destination.shortName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.h2.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).arriveSummary(arrival, remainingMin, remainingKm.toStringAsFixed(1)),
                      style: type.body.copyWith(color: colors.secondaryText),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: booking.routeProgress.clamp(0.05, 1.0),
                        backgroundColor: colors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 18),
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
                            icon: AppIcons.shield_exclamation,
                            label: AppLocalizations.of(context).sosLabel,
                            destructive: true,
                            onTap: () => AppToast.error(
                              context,
                              AppLocalizations.of(context).sosAlertToast,
                              title: AppLocalizations.of(context).sosAlertSent,
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
