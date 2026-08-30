import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/utils/geo_utils.dart';

class BulkOfferDetailsScreen extends ConsumerWidget {
  const BulkOfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkState = ref.watch(bulkBookingControllerProvider);
    final offer = bulkState.offer;
    final request = bulkState.request;

    if (offer == null) {
      return AppScaffold(appBar: AppBar(), body: const Center(child: Text('No offer available.')));
    }

    return AppScaffold(
      appBar: AppBar(title: const Text('Offer Details')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request != null) ...[
            RideMapView(
              pickup: request.pickup,
              destination: request.destination,
              showDestination: true,
              height: 180,
              borderRadius: BorderRadius.circular(AppRadius.card),
              interactive: false,
              enableExpand: false,
            ),
            const SizedBox(height: 16),
          ],
          Text('Driver & Vehicle List', style: AppTypography.of(context).h3),
          const SizedBox(height: 12),
          for (final v in offer.vehicles)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.of(context).card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.of(context).border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: AppColors.of(context).navySecondary, shape: BoxShape.circle),
                        child: const Icon(BootstrapIcons.person_fill, color: Colors.white, size: 22),
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
                                Text('${v.rating}', style: AppTypography.of(context).caption),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(formatRupees(v.fareShare), style: AppTypography.of(context).label),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: AppColors.of(context).border),
                  const SizedBox(height: 10),
                  Text('${v.vehicleModel} · ${v.registrationNumber}', style: AppTypography.of(context).body),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(v.category),
                      _Chip('${v.seats} Seater'),
                      if (v.ac) const _Chip('AC'),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text('Included Charges', style: AppTypography.of(context).h3),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: offer.includedCharges
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(BootstrapIcons.check, size: 18, color: AppColors.of(context).success),
                            const SizedBox(width: 8),
                            Text(c, style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).navy)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).primaryBackground, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Fare', style: AppTypography.of(context).label),
                Text(formatRupees(offer.totalFare), style: AppTypography.of(context).price.copyWith(color: AppColors.of(context).primaryDark)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Confirm Booking',
            onPressed: () {
              ref.read(bulkBookingControllerProvider.notifier).confirmOffer();
              context.push(AppRoutes.bulkBookingConfirmed);
            },
          ),
          const SizedBox(height: 10),
          AppOutlineButton(
            label: 'Contact Support / Request Change',
            onPressed: () => context.push(AppRoutes.helpSupport),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.badge)),
      child: Text(label, style: AppTypography.of(context).caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.of(context).navy)),
    );
  }
}
