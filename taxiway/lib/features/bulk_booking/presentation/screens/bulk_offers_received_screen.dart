import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/utils/geo_utils.dart';

class BulkOffersReceivedScreen extends ConsumerWidget {
  const BulkOffersReceivedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkState = ref.watch(bulkBookingControllerProvider);
    final request = bulkState.request;
    final offer = bulkState.offer;

    if (request == null || offer == null) {
      return AppScaffold(appBar: AppBar(), body: const Center(child: Text('No offer available yet.')));
    }

    return AppScaffold(
      appBar: AppBar(title: const Text('Offers Received')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${request.pickup.shortName} → ${request.destination.shortName}', style: AppTypography.of(context).h3),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('dd MMM yyyy').format(request.journeyDate)}, ${request.journeyTime} · '
                  '${request.numVehicles} vehicles · ${request.approxPassengers} passengers',
                  style: AppTypography.of(context).caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Vehicles Available', style: AppTypography.of(context).h2),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primaryBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final v in offer.vehicles) ...[
                  Row(
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
                            Row(
                              children: [
                                Text(v.driverName, style: AppTypography.of(context).label),
                                const SizedBox(width: 6),
                                if (v.verified)
                                  const StatusBadge(label: 'Verified', variant: BadgeVariant.verified),
                              ],
                            ),
                            Row(
                              children: [
                                RatingStars(rating: v.rating, size: 12),
                                const SizedBox(width: 4),
                                Text('${v.rating} · ${v.category} · ${v.seats} Seater', style: AppTypography.of(context).caption),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (v != offer.vehicles.last) const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                ],
                const SizedBox(height: 14),
                Container(height: 1, color: AppColors.of(context).border),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Fare', style: AppTypography.of(context).label),
                    Text(formatRupees(offer.totalFare), style: AppTypography.of(context).price.copyWith(color: AppColors.of(context).primaryDark)),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: 'View Details', onPressed: () => context.push(AppRoutes.bulkOfferDetails)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
