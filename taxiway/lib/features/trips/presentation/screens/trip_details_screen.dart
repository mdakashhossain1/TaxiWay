import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/trip_history_item.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/utils/geo_utils.dart';

class TripDetailsScreen extends ConsumerWidget {
  final TripHistoryItem item;
  const TripDetailsScreen({super.key, required this.item});

  String get _vehicleImage {
    final cat = item.booking.vehicleCategory.id.toLowerCase();
    if (cat.contains('hatchback')) return 'assets/images/car_hatchback.jpg';
    if (cat.contains('suv')) return 'assets/images/car_suv.jpg';
    if (cat.contains('traveller') || cat.contains('tempo')) return 'assets/images/car_traveller.jpg';
    return 'assets/images/car_sedan.jpg';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = item.booking;
    // This is a specific historical booking, not necessarily the currently
    // active one — always show the driver/vehicle that were actually
    // assigned to *this* trip, not whatever "current" happens to be.
    final driver = booking.driver;
    final vehicle = booking.vehicle;

    return AppScaffold(
      appBar: AppBar(
        title: Text('Trip Details', style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy)),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map preview
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: RideMapView(
              pickup: booking.pickup,
              destination: booking.destination,
              showDestination: true,
              height: 170,
            ),
          ),
          const SizedBox(height: 16),

          // Header ID & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip #${booking.id}',
                style: AppTypography.of(context).label.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.of(context).navy),
              ),
              StatusBadge(
                label: booking.status.name.toUpperCase(),
                variant: booking.status.name == 'completed' ? BadgeVariant.verified : BadgeVariant.pending,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(booking.createdAt),
            style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText),
          ),
          const SizedBox(height: 16),

          // Route Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row('Pickup', booking.pickup.address),
                _Row('Destination', booking.destination.address),
                _Row('Driver', driver?.name ?? '—'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vehicle', style: AppTypography.of(context).caption),
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 20,
                            margin: const EdgeInsets.only(right: 6),
                            child: Image.asset(_vehicleImage, fit: BoxFit.contain),
                          ),
                          Text(
                            vehicle != null ? '${vehicle.model} · ${vehicle.registrationNumber}' : '—',
                            style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _Row('Distance', '${booking.distanceKm.toStringAsFixed(1)} km'),
                _Row('Duration', '${booking.etaMinutes} min'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fare Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primary.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fare Invoice',
                  style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy),
                ),
                const SizedBox(height: 10),
                _Row('Base Fare', formatRupees(booking.fare.baseFare)),
                _Row('Distance Fare', formatRupees(booking.fare.distanceFare)),
                _Row('Time Fare', formatRupees(booking.fare.timeFare)),
                const Divider(height: 18),
                _Row('Total Paid', formatRupees(booking.fare.total), emphasize: true),
                const SizedBox(height: 6),
                _Row('Payment Method', booking.paymentMethod.toUpperCase()),
                _Row('Payment Status', booking.paymentStatus),
              ],
            ),
          ),

          if (item.ratingGiven != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.of(context).card,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.of(context).border),
              ),
              child: Row(
                children: [
                  Text('Your Rating', style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy)),
                  const SizedBox(width: 10),
                  RatingStars(rating: item.ratingGiven!, size: 16),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          AppOutlineButton(
            label: 'Contact Support',
            icon: BootstrapIcons.headset,
            onPressed: () => context.push(AppRoutes.helpSupport),
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
  final bool emphasize;
  const _Row(this.label, this.value, {this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasize ? AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy) : AppTypography.of(context).caption),
          Flexible(
            child: Text(
              value,
              style: emphasize
                  ? AppTypography.of(context).h3.copyWith(color: AppColors.of(context).primaryDark, fontWeight: FontWeight.w700)
                  : AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
