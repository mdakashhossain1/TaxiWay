import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_success_check.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/utils/geo_utils.dart';

class BulkBookingConfirmedScreen extends ConsumerWidget {
  const BulkBookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkState = ref.watch(bulkBookingControllerProvider);
    final request = bulkState.request;
    final offer = bulkState.offer;

    if (request == null || offer == null) {
      return AppScaffold(appBar: AppBar(), body: const Center(child: Text('No confirmed booking found.')));
    }

    return AppScaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnimatedSuccessCheck(size: 50, iconSize: 30),
          const SizedBox(height: 14),
          Text('Bulk Booking Confirmed', style: AppTypography.of(context).h1)
              .animate()
              .fadeIn(delay: 150.ms, duration: 350.ms)
              .slideY(begin: 0.15, end: 0, delay: 150.ms, duration: 350.ms),
          const SizedBox(height: 18),
          RideMapView(
            pickup: request.pickup,
            destination: request.destination,
            showDestination: true,
            height: 180,
            borderRadius: BorderRadius.circular(AppRadius.card),
            interactive: false,
            enableExpand: false,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.of(context).border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row('Booking ID', request.id),
                _Row('Route', '${request.pickup.shortName} → ${request.destination.shortName}'),
                _Row('Date', '${DateFormat('dd MMM yyyy').format(request.journeyDate)}, ${request.journeyTime}'),
                _Row('Vehicles Confirmed', '${offer.vehicles.length}'),
                _Row('Total Capacity', '${offer.totalCapacity} seats'),
                _Row('Total Fare', formatRupees(offer.totalFare)),
                _Row('Payment Status', 'Pending'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Your Drivers', style: AppTypography.of(context).h3),
          const SizedBox(height: 10),
          for (final v in offer.vehicles)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.medium)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.of(context).navySecondary, shape: BoxShape.circle),
                    child: const Icon(BootstrapIcons.person_fill, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.driverName, style: AppTypography.of(context).label),
                        Row(
                          children: [
                            RatingStars(rating: v.rating, size: 12),
                            const SizedBox(width: 4),
                            Text('${v.vehicleModel} · ${v.registrationNumber}', style: AppTypography.of(context).caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Back to Home',
            onPressed: () {
              ref.read(bulkBookingControllerProvider.notifier).clear();
              context.go(AppRoutes.home);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.of(context).caption),
          Flexible(child: Text(value, style: AppTypography.of(context).label, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
