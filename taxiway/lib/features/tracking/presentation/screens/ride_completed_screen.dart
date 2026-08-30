import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/trip_history_item.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_success_check.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/utils/geo_utils.dart';

class RideCompletedScreen extends ConsumerWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingControllerProvider);
    final driver = ref.watch(currentDriverProvider);
    final vehicle = ref.watch(currentVehicleProvider);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('No completed ride found.')));
    }

    return AppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Trip Completed', style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy)),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                const AnimatedSuccessCheck(size: 56, iconSize: 32),
                const SizedBox(height: 14),
                Text(
                  'Ride Completed!',
                  style: AppTypography.of(context).h1.copyWith(fontSize: 24, color: AppColors.of(context).navy, fontWeight: FontWeight.w700),
                ).animate().fadeIn(delay: 150.ms, duration: 300.ms).slideY(begin: 0.15, end: 0),
                const SizedBox(height: 4),
                Text(
                  'Hope you enjoyed your ride with Taxiway.',
                  style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).bodyText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Total Fare Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Paid', style: AppTypography.of(context).label.copyWith(fontSize: 15, color: AppColors.of(context).navy)),
                    Text(
                      formatRupees(booking.fare.total),
                      style: AppTypography.of(context).h1.copyWith(
                        fontSize: 24,
                        color: AppColors.of(context).primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: AppColors.of(context).primary.withValues(alpha: 0.15)),
                const SizedBox(height: 10),
                _Detail('Payment Method', booking.paymentMethod.toUpperCase()),
                _Detail('Payment Status', booking.paymentStatus),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 16),

          // Trip Breakdown Details
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Details',
                  style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy),
                ),
                const SizedBox(height: 12),
                _Detail('Pickup', booking.pickup.shortName),
                _Detail('Destination', booking.destination.shortName),
                _Detail('Distance', '${booking.distanceKm.toStringAsFixed(1)} km'),
                _Detail('Duration', '${booking.etaMinutes} min'),
                _Detail('Driver', driver.name),
                _Detail('Vehicle', '${vehicle.model} (${vehicle.registrationNumber})'),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 300.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 28),

          PrimaryButton(
            label: 'Rate Your Ride ⭐',
            onPressed: () => context.push(AppRoutes.ratingReview),
          ),

          const SizedBox(height: 10),

          AppOutlineButton(
            label: 'View Full Invoice',
            icon: BootstrapIcons.receipt,
            onPressed: () => context.push(AppRoutes.tripDetails, extra: TripHistoryItem(booking: booking)),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String label;
  final String value;
  const _Detail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: AppTypography.of(context).bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.of(context).navy,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
