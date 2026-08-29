import 'dart:async';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/place_location.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/ride_map_view.dart';

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends ConsumerState<DestinationSearchScreen> {
  final _controller = TextEditingController();
  List<PlaceLocation> _results = [];
  List<PlaceLocation> _recent = [];
  PlaceLocation? _selected;
  bool _loading = false;
  bool _searching = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final repo = ref.read(placeRepositoryProvider);
    final history = await repo.getRecentHistory();
    if (!mounted) return;
    setState(() {
      _recent = history;
    });
  }

  Future<void> _deleteRecent(PlaceLocation place) async {
    final repo = ref.read(placeRepositoryProvider);
    await repo.removeRecent(place);
    setState(() {
      _recent.removeWhere((p) => p == place || p.address == place.address);
    });
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _searching = false;
        _results = [];
        _loading = false;
      });
      _loadRecent();
      return;
    }

    setState(() {
      _searching = true;
      _loading = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      final origin = ref.read(bookingDraftControllerProvider).pickup ??
          ref.read(placeRepositoryProvider).currentLocation;
      final repo = ref.read(placeRepositoryProvider);
      final results = await repo.search(trimmed, proximityOrigin: origin);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    });
  }

  void _selectPlace(PlaceLocation place) {
    setState(() {
      _selected = place;
      _controller.text = place.address;
    });
    FocusScope.of(context).unfocus();
    // Add to persistent search history
    ref.read(placeRepositoryProvider).addRecent(place);
  }

  Future<void> _onMapTapped(double lat, double lng) async {
    final resolved = await resolveExactPlaceLocation(
      latitude: lat,
      longitude: lng,
    );
    if (!mounted) return;
    setState(() {
      _selected = resolved;
    });
    ref.read(placeRepositoryProvider).addRecent(resolved);
  }

  void _confirmSelection() {
    if (_selected == null) return;
    ref.read(placeRepositoryProvider).addRecent(_selected!);
    Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final pickup = ref.read(bookingDraftControllerProvider).pickup ??
        ref.read(placeRepositoryProvider).currentLocation;

    final distanceKm = _selected != null ? haversineKm(pickup, _selected!) : null;
    final etaMin = distanceKm != null ? ((distanceKm / 28.0) * 60).round().clamp(3, 180) : null;

    return AppScaffold(
      appBar: AppBar(title: const Text('Destination')),
      padHorizontal: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Real-Time Road Navigation Map at top showing Pickup to Destination route
          RideMapView(
            pickup: pickup,
            destination: _selected,
            showDestination: _selected != null,
            distanceKm: distanceKm,
            etaMinutes: etaMin,
            height: 280,
            borderRadius: BorderRadius.zero,
            onMapTap: (latLng) => _onMapTapped(latLng.latitude, latLng.longitude),
            onRecenter: () {
              ref.read(bookingDraftControllerProvider.notifier).refreshCurrentGpsLocation();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              _selected != null
                  ? 'Showing live road route to selected destination. Tap map or search to change.'
                  : 'Tap on map or search below to see live road route.',
              style: AppTypography.caption.copyWith(
                color: _selected != null ? AppColors.primaryDark : AppColors.mutedText,
                fontWeight: _selected != null ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text('Where do you want to go?', style: AppTypography.h2),
                  const SizedBox(height: 12),
                  // Search text input with clear button
                  TextField(
                    controller: _controller,
                    onChanged: _onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Search destination on real map...',
                      prefixIcon: const Icon(BootstrapIcons.search, size: 18, color: AppColors.primary),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.mutedText),
                              onPressed: () {
                                _controller.clear();
                                _onQueryChanged('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: const BorderSide(color: AppColors.border, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searching
                            ? 'Closest Matches (${_results.length})'
                            : 'Recent Search History',
                        style: AppTypography.label.copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_searching && _recent.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            await ref.read(placeRepositoryProvider).clearRecentHistory();
                            setState(() => _recent.clear());
                          },
                          child: Text(
                            'Clear all',
                            style: AppTypography.caption.copyWith(color: AppColors.error),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // List of search results or recent search history
                  Expanded(
                    child: _loading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          )
                        : _searching
                            ? _buildSearchResults(pickup)
                            : _buildRecentHistory(pickup),
                  ),
                  // Confirmation button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: PrimaryButton(
                      label: _selected != null
                          ? 'Confirm Destination'
                          : 'Select Destination from Map / List',
                      onPressed: _selected != null ? _confirmSelection : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(PlaceLocation origin) {
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(BootstrapIcons.geo_alt, size: 36, color: AppColors.mutedText),
              const SizedBox(height: 8),
              Text(
                'No exact match found on map.',
                style: AppTypography.label,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap on the map directly to select this spot.',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, i) {
        final place = _results[i];
        final isSelected = _selected?.address == place.address;
        final distanceKm = haversineKm(origin, place);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBackground : AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              BootstrapIcons.geo_alt_fill,
              color: isSelected ? AppColors.primary : AppColors.secondaryText,
              size: 16,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  place.shortName,
                  style: AppTypography.label.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? AppColors.primaryDark : AppColors.navy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${distanceKm.toStringAsFixed(1)} km',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            place.address,
            style: AppTypography.caption.copyWith(color: AppColors.bodyText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          selected: isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
          onTap: () => _selectPlace(place),
        );
      },
    );
  }

  Widget _buildRecentHistory(PlaceLocation origin) {
    if (_recent.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(BootstrapIcons.clock_history, size: 36, color: AppColors.mutedText),
              const SizedBox(height: 8),
              Text('No recent searches', style: AppTypography.label.copyWith(color: AppColors.secondaryText)),
              const SizedBox(height: 4),
              Text(
                'Type above to search real places or tap on the map.',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _recent.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, i) {
        final place = _recent[i];
        final isSelected = _selected?.address == place.address;
        final distanceKm = haversineKm(origin, place);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              BootstrapIcons.clock_history,
              color: AppColors.secondaryText,
              size: 16,
            ),
          ),
          title: Text(
            place.shortName,
            style: AppTypography.label.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? AppColors.primaryDark : AppColors.navy,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  place.address,
                  style: AppTypography.caption.copyWith(color: AppColors.bodyText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${distanceKm.toStringAsFixed(1)} km',
                style: AppTypography.caption.copyWith(color: AppColors.mutedText),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.mutedText),
            tooltip: 'Remove from history',
            onPressed: () => _deleteRecent(place),
          ),
          selected: isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
          onTap: () => _selectPlace(place),
        );
      },
    );
  }
}
