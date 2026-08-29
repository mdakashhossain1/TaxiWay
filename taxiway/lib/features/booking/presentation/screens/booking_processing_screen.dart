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

class BookingProcessingScreen extends ConsumerWidget {
  const BookingProcessingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingControllerProvider);

    ref.listen(bookingControllerProvider, (previous, next) {
      if (next != null &&
          next.status != BookingStatus.requested &&
          next.status != BookingStatus.allocating &&
          next.status != BookingStatus.driverOffered) {
        if (next.status == BookingStatus.cancelled) {
          context.go(AppRoutes.home);
        } else {
          context.pushReplacement(AppRoutes.bookingConfirmed);
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
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.bottomSheet),
                  boxShadow: AppShadows.elevated,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    Text('Finding a suitable driver...', style: AppTypography.h3, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      'This usually takes a few seconds.',
                      style: AppTypography.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    DestructiveButton(
                      label: 'Cancel Request',
                      onPressed: () {
                        ref.read(bookingControllerProvider.notifier).cancelBooking();
                      },
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
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(begin: const Offset(0.4, 0.4), end: const Offset(2.2, 2.2), duration: 1800.ms, curve: Curves.easeOut)
            .fadeOut(duration: 1800.ms, curve: Curves.easeIn),
      ),
    );
  }
}
