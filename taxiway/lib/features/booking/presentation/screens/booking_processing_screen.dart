import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/booking.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../l10n/generated/app_localizations.dart';

class BookingProcessingScreen extends ConsumerWidget {
  const BookingProcessingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final booking = ref.watch(bookingControllerProvider);

    ref.listen(bookingControllerProvider, (previous, next) {
      // scheduledOpen isn't "confirmed" — it means the ride was broadcast to
      // eligible drivers and nobody has accepted yet, which can take a long
      // time by design (see RebroadcastScheduledRides). In practice this
      // screen is skipped entirely for scheduled bookings (see
      // booking_review_screen.dart), but this guard keeps the check correct
      // regardless of how the screen is reached.
      if (next != null &&
          next.status != BookingStatus.requested &&
          next.status != BookingStatus.allocating &&
          next.status != BookingStatus.driverOffered &&
          next.status != BookingStatus.scheduledOpen) {
        if (next.status == BookingStatus.cancelled) {
          context.go(AppRoutes.home);
        } else {
          context.pushReplacement(AppRoutes.liveTracking);
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RideMapView(
              pickup: booking?.pickup,
              destination: booking?.destination,
              showDestination: true,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          ),
          const Positioned.fill(child: SearchPulseOverlay()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.of(context).card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
                boxShadow: AppShadows.sheet,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        color: AppColors.of(context).primary,
                        backgroundColor: AppColors.of(context).surface,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.findingDriverHeading,
                            style: AppTypography.of(context).h2.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.findingDriverSubtitle,
                            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).secondaryText),
                          ),
                          const SizedBox(height: 20),
                          SecondaryButton(
                            label: l10n.cancelRequestLabel,
                            onPressed: () {
                              ref.read(bookingControllerProvider.notifier).cancelBooking();
                            },
                          ),
                        ],
                      ),
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

class SearchPulseOverlay extends StatelessWidget {
  const SearchPulseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.of(context).accent.withValues(alpha: 0.16),
            border: Border.all(color: AppColors.of(context).accent.withValues(alpha: 0.5), width: 2),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(begin: const Offset(0.4, 0.4), end: const Offset(2.2, 2.2), duration: 1800.ms, curve: Curves.easeOut)
            .fadeOut(duration: 1800.ms, curve: Curves.easeIn),
      ),
    );
  }
}
