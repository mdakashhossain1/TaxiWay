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
import '../../../../core/widgets/location_picker_map.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PickupSearchScreen extends ConsumerStatefulWidget {
  const PickupSearchScreen({super.key});

  @override
  ConsumerState<PickupSearchScreen> createState() => _PickupSearchScreenState();
}

class _PickupSearchScreenState extends ConsumerState<PickupSearchScreen> {
  final _controller = TextEditingController();
  final _mapKey = GlobalKey<LocationPickerMapState>();
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
      final origin = ref.read(placeRepositoryProvider).currentLocation;
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
    _mapKey.currentState?.animateTo(place);
    ref.read(placeRepositoryProvider).addRecent(place);
  }

  void _confirmSelection() {
    if (_selected == null) return;
    ref.read(placeRepositoryProvider).addRecent(_selected!);
    Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocation = ref.read(placeRepositoryProvider).currentLocation;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.pickupLocationTitle)),
      padHorizontal: false,
      body: Column(
        children: [
          // Map preview at top
          LocationPickerMap(
            key: _mapKey,
            initial: currentLocation,
            onLocationChanged: (loc) {
              setState(() {
                _selected = loc;
              });
            },
            height: 200,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              l10n.dragMapPickupHint,
              style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _controller,
                    onChanged: _onQueryChanged,
                    decoration: InputDecoration(
                      hintText: l10n.searchPickupMapHint,
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
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).primaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(BootstrapIcons.crosshair, color: AppColors.of(context).primary, size: 16),
                    ),
                    title: Text(l10n.useCurrentGpsLocation, style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text(l10n.detectLocationAutomatically, style: AppTypography.of(context).caption),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _mapKey.currentState?.useCurrentLocation();
                    },
                  ),
                  Divider(height: 1, color: AppColors.of(context).border),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searching
                            ? l10n.closestResultsLabel(_results.length)
                            : l10n.recentPickupsLabel,
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
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
                        : _searching
                            ? _buildSearchResults(currentLocation)
                            : _buildRecentHistory(currentLocation),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: PrimaryButton(
                      label: _selected != null ? l10n.confirmPickupLabel : l10n.selectPickupLocationLabel,
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
              Text(l10n.noExactMatchTitle, style: AppTypography.of(context).label),
              const SizedBox(height: 4),
              Text(l10n.dragPinToSelectHint, style: AppTypography.of(context).caption),
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
              Text(l10n.noRecentPickupsTitle, style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).secondaryText)),
              const SizedBox(height: 4),
              Text(
                l10n.searchPickupAboveHint,
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
