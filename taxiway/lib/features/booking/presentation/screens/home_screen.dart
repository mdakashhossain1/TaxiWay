import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/nearby_drivers.dart';
import '../../../../core/models/place_location.dart';
import '../../../../core/models/vehicle_category.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/inline_retry.dart';
import '../../../../core/widgets/location_card.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/schedule_toggle_card.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/upcoming_scheduled_ride_card.dart';
import '../../../../core/widgets/vehicle_option_tile.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/widgets/auto_scroll_text.dart';

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
    final draft = ref.watch(bookingDraftControllerProvider);
    final colors = AppColors.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? true;
    final nearbyDrivers = draft.pickup == null || !isCurrentRoute
        ? const <LatLng>[]
        : (ref.watch(nearbyDriversProvider(draft.pickup!)).asData?.value ?? const []).map((d) => LatLng(d.lat, d.lng)).toList();

    return Scaffold(
      backgroundColor: colors.appBackground,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => RideMapView(
                    pickup: draft.pickup,
                    destination: draft.destination,
                    showDestination: draft.hasRoute,
                    distanceKm: draft.hasRoute ? draft.distanceKm : null,
                    etaMinutes: draft.hasRoute ? draft.etaMinutes : null,
                    height: constraints.maxHeight,
                    borderRadius: BorderRadius.zero,
                    enableExpand: false,
                    nearbyDrivers: nearbyDrivers,
                    onRecenter: () => ref.read(bookingDraftControllerProvider.notifier).refreshCurrentGpsLocation(),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight * (draft.hasRoute ? 0.66 : 0.52)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
                    boxShadow: AppShadows.sheet,
                  ),
                  child: SafeArea(
                    top: false,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: draft.hasRoute
                          ? _RideOptionsSheet(
                              onPickPickup: () => _pickPickup(context, ref),
                              onPickDestination: () => _pickDestination(context, ref),
                              onSwap: () => _swap(ref, draft.pickup!, draft.destination!),
                            )
                          : _DestinationSheet(
                              onPickPickup: () => _pickPickup(context, ref),
                              onPickDestination: () => _pickDestination(context, ref),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [_MapButton(icon: AppIcons.person_fill, filled: true, onTap: () => context.push(AppRoutes.profileMenu))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _MapButton({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return PressableScale(
      pressedScale: 0.92,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(color: filled ? colors.primary : colors.card, shape: BoxShape.circle, boxShadow: AppShadows.elevated),
          child: Icon(icon, size: 20, color: filled ? colors.onPrimary : colors.navy),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 14),
        height: 4,
        width: 36,
        decoration: BoxDecoration(color: AppColors.of(context).borderStrong, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

class _DestinationSheet extends ConsumerWidget {
  final VoidCallback onPickPickup;
  final VoidCallback onPickDestination;

  const _DestinationSheet({required this.onPickPickup, required this.onPickDestination});

  List<PlaceLocation> _recentDestinations(WidgetRef ref) {
    final trips = ref.watch(tripHistoryControllerProvider).value ?? const [];
    final seen = <PlaceLocation>{};
    for (final item in trips) {
      seen.add(item.booking.destination);
      if (seen.length == 4) break;
    }
    return seen.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final draft = ref.watch(bookingDraftControllerProvider);
    final recents = _recentDestinations(ref);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          const UpcomingScheduledRideCard(),
          PressableScale(
            pressedScale: 0.98,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPickDestination,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(AppRadius.card)),
                child: Row(
                  children: [
                    Icon(AppIcons.search, size: 22, color: colors.navy),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.whereDoYouWantToGo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: type.h3.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPickPickup,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(color: colors.navy, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: AutoScrollText(
                      draft.pickup?.shortName ?? l10n.searchPickup,
                      style: type.body.copyWith(color: colors.secondaryText, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(AppIcons.chevron_right, size: 16, color: colors.mutedText),
                ],
              ),
            ),
          ),
          if (recents.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (var i = 0; i < recents.length; i++)
              _PlaceRow(
                place: recents[i],
                onTap: () => ref.read(bookingDraftControllerProvider.notifier).setDestination(recents[i]),
              ).animate().fadeIn(delay: (50 * i).ms, duration: 220.ms),
          ],
          const SizedBox(height: 8),
          Divider(color: colors.border),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (draft.pickup != null) {
                ref.read(bulkBookingDraftControllerProvider.notifier).setPickup(draft.pickup!);
              }
              context.push(AppRoutes.bulkTripCapacity);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                    child: Icon(AppIcons.people_fill, size: 18, color: colors.navy),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.bulkBookingTitle, style: type.label.copyWith(fontWeight: FontWeight.w700)),
                        Text(
                          l10n.bulkBookingSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: colors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Icon(AppIcons.chevron_right, size: 16, color: colors.mutedText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  final PlaceLocation place;
  final VoidCallback onTap;

  const _PlaceRow({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final rest = place.address.contains(',') ? place.address.substring(place.address.indexOf(',') + 1).trim() : '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
              child: Icon(AppIcons.clock_history, size: 18, color: colors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoScrollText(place.shortName, style: type.label.copyWith(fontWeight: FontWeight.w700)),
                  if (rest.isNotEmpty) AutoScrollText(rest, style: type.caption.copyWith(color: colors.secondaryText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RideOptionsSheet extends ConsumerWidget {
  final VoidCallback onPickPickup;
  final VoidCallback onPickDestination;
  final VoidCallback onSwap;

  const _RideOptionsSheet({required this.onPickPickup, required this.onPickDestination, required this.onSwap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final type = AppTypography.of(context);
    final draft = ref.watch(bookingDraftControllerProvider);
    final controller = ref.read(bookingDraftControllerProvider.notifier);
    final categoriesAsync = ref.watch(vehicleCategoriesProvider);

    final fare = draft.selectedCategory != null ? controller.fareFor(draft.selectedCategory!) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SheetHandle(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LocationCard(
            pickup: draft.pickup,
            destination: draft.destination,
            onTapPickup: onPickPickup,
            onTapDestination: onPickDestination,
            onSwap: onSwap,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: ScheduleToggleCard()),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(l10n.selectVehicle, style: type.h3.copyWith(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 6),
        Flexible(
          child: categoriesAsync.when(
            skipLoadingOnReload: true,
            skipError: true,
            loading: () => const VehicleOptionListSkeleton(),
            error: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InlineRetry(message: l10n.couldNotLoadVehicles, onRetry: () => ref.invalidate(vehicleCategoriesProvider)),
            ),
            data: (categories) {
              _ensureSelection(ref, draft.selectedCategory, categories);

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, i) {
                  final category = categories[i];
                  final categoryFare = controller.fareFor(category);
                  final delay = (40 * (i < 6 ? i : 6)).ms;
                  return VehicleOptionTile(
                        category: category,
                        fare: categoryFare?.total ?? category.minimumFare,
                        selected: draft.selectedCategory?.id == category.id,
                        onTap: () => controller.selectCategory(category),
                      )
                      .animate()
                      .fadeIn(delay: delay, duration: 220.ms)
                      .slideY(begin: 0.12, end: 0, delay: delay, duration: 220.ms, curve: Curves.easeOutCubic);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: draft.selectedCategory != null ? () => context.push(AppRoutes.bookingReview) : null,
              child: Text(
                fare != null
                    ? '${draft.isScheduled ? l10n.scheduleRide : l10n.bookRide} ${draft.selectedCategory!.name} · ${formatRupees(fare.total)}'
                    : l10n.selectAVehicle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _ensureSelection(WidgetRef ref, VehicleCategory? selected, List<VehicleCategory> categories) {
    if (selected != null || categories.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingDraftControllerProvider.notifier).selectCategory(categories.first);
    });
  }
}
