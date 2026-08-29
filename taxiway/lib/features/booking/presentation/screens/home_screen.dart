import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/place_location.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/fare_card.dart';
import '../../../../core/widgets/location_card.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/taxiway_header.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/vehicle_card.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _pickPickup(BuildContext context, WidgetRef ref) async {
    final result = await context.push<PlaceLocation>(AppRoutes.pickupSearch);
    if (result != null) {
      ref.read(bookingDraftControllerProvider.notifier).setPickup(result);
    }
  }

  Future<void> _pickDestination(BuildContext context, WidgetRef ref) async {
    final result = await context.push<PlaceLocation>(AppRoutes.destinationSearch);
    if (result != null) {
      ref.read(bookingDraftControllerProvider.notifier).setDestination(result);
    }
  }

  void _swap(WidgetRef ref, PlaceLocation pickup, PlaceLocation destination) {
    final notifier = ref.read(bookingDraftControllerProvider.notifier);
    notifier.setPickup(destination);
    notifier.setDestination(pickup);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftControllerProvider);
    final categoriesAsync = ref.watch(vehicleCategoriesProvider);

    final fare = draft.selectedCategory != null
        ? ref.read(bookingDraftControllerProvider.notifier).fareFor(draft.selectedCategory!)
        : null;

    final mapHeight = draft.hasRoute ? 270.0 : 330.0;

    return AppScaffold(
      scrollable: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar with Taxiway logo, "Safe. Reliable. Anytime." & Profile
            TaxiwayHeader(onProfileTap: () => context.push(AppRoutes.profileMenu)),
            const SizedBox(height: 8),

            // Hero Interactive Map with Expand/Zoom Mode & Floating Metrics
            RideMapView(
              pickup: draft.pickup,
              destination: draft.destination,
              showDestination: draft.hasRoute,
              distanceKm: draft.hasRoute ? draft.distanceKm : null,
              etaMinutes: draft.hasRoute ? draft.etaMinutes : null,
              height: mapHeight,
              onRecenter: () {
                ref.read(bookingDraftControllerProvider.notifier).refreshCurrentGpsLocation();
              },
            ),
            const SizedBox(height: 16),

            // Route From (Pickup) / To (Destination) Card
            LocationCard(
              pickup: draft.pickup,
              destination: draft.destination,
              onTapPickup: () => _pickPickup(context, ref),
              onTapDestination: () => _pickDestination(context, ref),
              onSwap: draft.hasRoute ? () => _swap(ref, draft.pickup!, draft.destination!) : null,
            ),

            const SizedBox(height: 20),

            // Section Header: Select Vehicle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Vehicle',
                  style: AppTypography.h2.copyWith(fontSize: 18, color: AppColors.navy),
                ),
                if (draft.selectedCategory != null)
                  Text(
                    '${draft.selectedCategory!.seats} seats',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Horizontal Vehicle Carousel matching Figma design
            SizedBox(
              height: 180,
              child: categoriesAsync.when(
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, _) => const VehicleCardSkeleton(),
                ),
                error: (_, _) => const Text("Couldn't load vehicles."),
                data: (categories) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final category = categories[i];
                    final categoryFare = ref.read(bookingDraftControllerProvider.notifier).fareFor(category);
                    return VehicleCard(
                      category: category,
                      fare: categoryFare?.total ?? category.minimumFare,
                      selected: draft.selectedCategory?.id == category.id,
                      onTap: () {
                        ref.read(bookingDraftControllerProvider.notifier).selectCategory(category);
                        if (!draft.hasRoute) {
                          _pickDestination(context, ref);
                        }
                      },
                    )
                        .animate()
                        .fadeIn(delay: (40 * i).ms, duration: 220.ms)
                        .slideX(begin: 0.12, end: 0, delay: (40 * i).ms, duration: 220.ms, curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ),

            if (draft.hasRoute) ...[
              if (fare != null) ...[
                const SizedBox(height: 16),
                // Detailed Breakdown Strip
                FareCard(
                  fare: fare,
                  distanceKm: draft.distanceKm,
                  etaMinutes: draft.etaMinutes,
                )
                    .animate(key: ValueKey(fare.total))
                    .fadeIn(duration: 200.ms)
                    .scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), duration: 200.ms, curve: Curves.easeOutBack),
              ],

              const SizedBox(height: 20),

              // Primary CTA: Book Ride ₹XXX ->
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (draft.selectedCategory != null && draft.hasRoute)
                      ? () => context.push(AppRoutes.bookingReview)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    textStyle: AppTypography.button.copyWith(fontSize: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fare != null ? 'Book Ride ${formatRupees(fare.total)}' : 'Select a Vehicle',
                      ),
                      const SizedBox(width: 8),
                      const Icon(BootstrapIcons.arrow_right, size: 18),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Bulk Booking Promotional Card
            GestureDetector(
              onTap: () {
                if (draft.pickup != null) {
                  ref.read(bulkBookingDraftControllerProvider.notifier).setPickup(draft.pickup!);
                }
                context.push(AppRoutes.bulkTripCapacity);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: const Icon(BootstrapIcons.people_fill, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.bulkBookingTitle, style: AppTypography.h3.copyWith(color: AppColors.navy)),
                          const SizedBox(height: 2),
                          Text(l10n.bulkBookingSubtitle, style: AppTypography.caption.copyWith(color: AppColors.bodyText)),
                        ],
                      ),
                    ),
                    const Icon(BootstrapIcons.chevron_right, color: AppColors.mutedText, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
