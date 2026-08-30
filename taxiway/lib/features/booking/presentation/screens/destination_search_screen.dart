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
import '../../../../l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final pickup = ref.read(bookingDraftControllerProvider).pickup ??
        ref.read(placeRepositoryProvider).currentLocation;

    final distanceKm = _selected != null ? haversineKm(pickup, _selected!) : null;
    final etaMin = distanceKm != null ? ((distanceKm / 28.0) * 60).round().clamp(3, 180) : null;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.destinationLabel)),
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
                  ? l10n.liveRouteShowingHint
                  : l10n.tapMapToSeeRouteHint,
              style: AppTypography.of(context).caption.copyWith(
                color: _selected != null ? AppColors.of(context).primaryDark : AppColors.of(context).mutedText,
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
                  Text(l10n.whereDoYouWantToGo, style: AppTypography.of(context).h2),
                  const SizedBox(height: 12),
                  // Search text input with clear button
                  TextField(
                    controller: _controller,
                    onChanged: _onQueryChanged,
                    decoration: InputDecoration(
                      hintText: l10n.searchDestinationMapHint,
                      prefixIcon: Icon(BootstrapIcons.search, size: 18, color: AppColors.of(context).primary),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded, size: 20, color: AppColors.of(context).mutedText),
                              onPressed: () {
                                _controller.clear();
                                _onQueryChanged('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.of(context).surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: AppColors.of(context).primary, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: AppColors.of(context).border, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: AppColors.of(context).primary, width: 1.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searching
                            ? l10n.closestMatchesLabel(_results.length)
                            : l10n.recentSearchHistoryLabel,
                        style: AppTypography.of(context).label.copyWith(
                          color: AppColors.of(context).secondaryText,
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
                            l10n.clearAllLabel,
                            style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).error),
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
                          ? l10n.confirmDestinationLabel
                          : l10n.selectDestinationFromMapLabel,
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
    final l10n = AppLocalizations.of(context);
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(BootstrapIcons.geo_alt, size: 36, color: AppColors.of(context).mutedText),
              const SizedBox(height: 8),
              Text(
                l10n.noExactMatchTitle,
                style: AppTypography.of(context).label,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.tapMapDirectlyHint,
                style: AppTypography.of(context).caption,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.of(context).border),
      itemBuilder: (context, i) {
        final place = _results[i];
        final isSelected = _selected?.address == place.address;
        final distanceKm = haversineKm(origin, place);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.of(context).primaryBackground : AppColors.of(context).surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              BootstrapIcons.geo_alt_fill,
              color: isSelected ? AppColors.of(context).primary : AppColors.of(context).secondaryText,
              size: 16,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  place.shortName,
                  style: AppTypography.of(context).label.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.of(context).surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${distanceKm.toStringAsFixed(1)} km',
                  style: AppTypography.of(context).caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.of(context).primaryDark,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            place.address,
            style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
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
    final l10n = AppLocalizations.of(context);
    if (_recent.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(BootstrapIcons.clock_history, size: 36, color: AppColors.of(context).mutedText),
              const SizedBox(height: 8),
              Text(l10n.noRecentSearchesTitle, style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).secondaryText)),
              const SizedBox(height: 4),
              Text(
                l10n.typeAboveToSearchHint,
                style: AppTypography.of(context).caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _recent.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.of(context).border),
      itemBuilder: (context, i) {
        final place = _recent[i];
        final isSelected = _selected?.address == place.address;
        final distanceKm = haversineKm(origin, place);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.of(context).surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              BootstrapIcons.clock_history,
              color: AppColors.of(context).secondaryText,
              size: 16,
            ),
          ),
          title: Text(
            place.shortName,
            style: AppTypography.of(context).label.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  place.address,
                  style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${distanceKm.toStringAsFixed(1)} km',
                style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.close_rounded, size: 18, color: AppColors.of(context).mutedText),
            tooltip: l10n.removeFromHistoryTooltip,
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
