import '../../../../core/theme/app_icons.dart';
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
import '../../../../l10n/generated/app_localizations.dart';

class BulkOfferDetailsScreen extends ConsumerWidget {
  const BulkOfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkState = ref.watch(bulkBookingControllerProvider);
    final offer = bulkState.offer;
    final request = bulkState.request;

    if (offer == null) {
      return AppScaffold(appBar: AppBar(), body: Center(child: Text(AppLocalizations.of(context).noOfferAvailable)));
    }

    return AppScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).offerDetails)),
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
          Text(AppLocalizations.of(context).driverAndVehicleList, style: AppTypography.of(context).h3),
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
                        child: const Icon(AppIcons.person_fill, color: Colors.white, size: 22),
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
                  SizedBox(height: 10),
                  Container(height: 1, color: AppColors.of(context).border),
                  SizedBox(height: 10),
                  Text('${v.vehicleModel} · ${v.registrationNumber}', style: AppTypography.of(context).body),
                  SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(v.category),
                      _Chip(AppLocalizations.of(context).seaterCount(v.seats)),
                      if (v.ac) _Chip(AppLocalizations.of(context).acLabel),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context).includedCharges, style: AppTypography.of(context).h3),
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
                            Icon(AppIcons.check, size: 18, color: AppColors.of(context).success),
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
                Text(AppLocalizations.of(context).totalFare, style: AppTypography.of(context).label),
                Text(formatRupees(offer.totalFare), style: AppTypography.of(context).price.copyWith(color: AppColors.of(context).primaryDark)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: AppLocalizations.of(context).confirmBooking,
            onPressed: () {
              ref.read(bulkBookingControllerProvider.notifier).confirmOffer();
              context.push(AppRoutes.bulkBookingConfirmed);
            },
          ),
          const SizedBox(height: 10),
          AppOutlineButton(
            label: AppLocalizations.of(context).contactSupportRequestChange,
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
