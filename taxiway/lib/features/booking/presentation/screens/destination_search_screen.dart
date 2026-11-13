import 'dart:async';

import '../../../../core/theme/app_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/place_location.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/widgets/network_error_view.dart';
import '../../../../core/widgets/auto_scroll_text.dart';

enum _Field { pickup, destination }

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends ConsumerState<DestinationSearchScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _pickupFocus = FocusNode();
  final _destinationFocus = FocusNode();
  _Field _active = _Field.destination;
  List<PlaceLocation> _results = [];
  List<PlaceLocation> _recent = [];
  PlaceLocation? _selected;
  bool _mapMode = false;
  bool _loading = false;
  bool _searching = false;
  Timer? _debounceTimer;
  Object? _failure;
  int _searchToken = 0;

  TextEditingController get _activeController => _active == _Field.pickup ? _pickupController : _destinationController;

  @override
  void initState() {
    super.initState();
    final pickup = ref.read(bookingDraftControllerProvider).pickup ?? ref.read(placeRepositoryProvider).currentLocation;
    _pickupController.text = pickup.shortName;
    _pickupFocus.addListener(() => _onFocusChanged(_Field.pickup, _pickupFocus));
    _destinationFocus.addListener(() => _onFocusChanged(_Field.destination, _destinationFocus));
    _loadRecent();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocus.dispose();
    _destinationFocus.dispose();
    super.dispose();
  }

  void _onFocusChanged(_Field field, FocusNode node) {
    if (!node.hasFocus) return;
    setState(() {
      _active = field;
      _mapMode = false;
    });
    if (field == _Field.pickup) {
      _pickupController.selection = TextSelection(baseOffset: 0, extentOffset: _pickupController.text.length);
    }
    _onQueryChanged(field == _Field.pickup ? '' : _destinationController.text);
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
    final token = ++_searchToken;
    if (trimmed.isEmpty) {
      setState(() {
        _searching = false;
        _results = [];
        _loading = false;
        _failure = null;
      });
      _loadRecent();
      return;
    }

    setState(() {
      _searching = true;
      _loading = true;
      _failure = null;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      final origin = ref.read(bookingDraftControllerProvider).pickup ?? ref.read(placeRepositoryProvider).currentLocation;
      final repo = ref.read(placeRepositoryProvider);
      try {
        final results = await repo.search(trimmed, proximityOrigin: origin);
        if (!mounted || token != _searchToken) return;
        setState(() {
          _results = results;
          _loading = false;
        });
      } catch (error) {
        if (!mounted || token != _searchToken) return;
        setState(() {
          _results = [];
          _failure = error;
          _loading = false;
        });
      }
    });
  }

  void _pick(PlaceLocation place) {
    ref.read(placeRepositoryProvider).addRecent(place);
    if (_active == _Field.pickup) {
      ref.read(bookingDraftControllerProvider.notifier).setPickup(place);
      _pickupController.text = place.shortName;
      _destinationFocus.requestFocus();
      return;
    }
    Navigator.of(context).pop(place);
  }

  Future<void> _onMapTapped(double lat, double lng) async {
    final resolved = await resolveExactPlaceLocation(latitude: lat, longitude: lng);
    if (!mounted) return;
    setState(() => _selected = resolved);
  }

  Future<void> _choosePickupOnMap() async {
    final result = await context.push<PlaceLocation>(AppRoutes.pickupSearch);
    if (result == null || !mounted) return;
    ref.read(bookingDraftControllerProvider.notifier).setPickup(result);
    _pickupController.text = result.shortName;
    _destinationFocus.requestFocus();
  }

  void _chooseOnMap() {
    if (_active == _Field.pickup) {
      _choosePickupOnMap();
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _mapMode = true);
  }

  void _clear(_Field field) {
    final controller = field == _Field.pickup ? _pickupController : _destinationController;
    controller.clear();
    if (field == _active) _onQueryChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final draft = ref.watch(bookingDraftControllerProvider);
    final pickup = draft.pickup ?? ref.read(placeRepositoryProvider).currentLocation;

    return Scaffold(
      backgroundColor: colors.appBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_mapMode) {
                        setState(() {
                          _mapMode = false;
                          _selected = null;
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(AppIcons.arrow_left, color: colors.navy, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.yourRouteTitle, style: type.h2.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: colors.navy, shape: BoxShape.circle),
                      ),
                      Container(width: 1.5, height: 50, color: colors.borderStrong),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        _RouteField(
                          controller: _pickupController,
                          focusNode: _pickupFocus,
                          hint: l10n.searchPickup,
                          active: _active == _Field.pickup,
                          onChanged: (value) {
                            _onQueryChanged(value);
                            setState(() {});
                          },
                          onClear: () => _clear(_Field.pickup),
                        ),
                        const SizedBox(height: 8),
                        _RouteField(
                          controller: _destinationController,
                          focusNode: _destinationFocus,
                          hint: l10n.whereDoYouWantToGo,
                          active: _active == _Field.destination,
                          autofocus: true,
                          bold: true,
                          onChanged: (value) {
                            _onQueryChanged(value);
                            setState(() {});
                          },
                          onClear: () => _clear(_Field.destination),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _mapMode ? _buildMapMode(pickup) : _buildList(pickup)),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMode(PlaceLocation pickup) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final distanceKm = _selected != null ? haversineKm(pickup, _selected!) : null;
    final etaMin = distanceKm != null ? ((distanceKm / 28.0) * 60).round().clamp(3, 180) : null;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => RideMapView(
              pickup: pickup,
              destination: _selected,
              showDestination: _selected != null,
              distanceKm: distanceKm,
              etaMinutes: etaMin,
              height: constraints.maxHeight,
              borderRadius: BorderRadius.zero,
              enableExpand: false,
              onMapTap: (latLng) => _onMapTapped(latLng.latitude, latLng.longitude),
              onRecenter: () => ref.read(bookingDraftControllerProvider.notifier).refreshCurrentGpsLocation(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selected?.address ?? l10n.tapMapToSeeRouteHint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: type.body.copyWith(color: _selected != null ? colors.navy : colors.secondaryText, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.confirmDestinationLabel,
                onPressed: _selected != null
                    ? () {
                        ref.read(placeRepositoryProvider).addRecent(_selected!);
                        Navigator.of(context).pop(_selected);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(PlaceLocation origin) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    if (_loading) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }
    if (_searching && _failure != null) {
      return NetworkErrorView(
        type: networkErrorTypeFor(_failure!),
        isCompact: true,
        onRetry: () async => _onQueryChanged(_activeController.text),
      );
    }
    if (_searching && _results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.geo_alt, size: 32, color: colors.mutedText),
              const SizedBox(height: 10),
              Text(l10n.noExactMatchTitle, textAlign: TextAlign.center, style: type.label),
              const SizedBox(height: 4),
              Text(l10n.tapMapDirectlyHint, textAlign: TextAlign.center, style: type.caption),
            ],
          ),
        ),
      );
    }

    final places = _searching ? _results : _recent;
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      itemCount: places.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChooseOnMapRow(label: l10n.chooseOnMapLabel, onTap: _chooseOnMap),
              if (places.isNotEmpty) ...[
                Divider(height: 1, color: colors.border),
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searching ? l10n.closestMatchesLabel(_results.length) : l10n.recentSearchHistoryLabel,
                        style: type.label.copyWith(color: colors.secondaryText),
                      ),
                      if (!_searching)
                        GestureDetector(
                          onTap: () async {
                            await ref.read(placeRepositoryProvider).clearRecentHistory();
                            setState(() => _recent.clear());
                          },
                          child: Text(l10n.clearAllLabel, style: type.caption.copyWith(color: colors.error)),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        }
        final place = places[i - 1];
        return _PlaceTile(
          place: place,
          distanceKm: haversineKm(origin, place),
          recent: !_searching,
          removeTooltip: l10n.removeFromHistoryTooltip,
          onTap: () => _pick(place),
          onRemove: _searching ? null : () => _deleteRecent(place),
        );
      },
    );
  }
}

class _RouteField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool active;
  final bool autofocus;
  final bool bold;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _RouteField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.active,
    required this.onChanged,
    required this.onClear,
    this.autofocus = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 52,
      padding: const EdgeInsets.only(left: 14, right: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? colors.card : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: active ? colors.primary : Colors.transparent, width: 1.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              onChanged: onChanged,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: colors.primary,
              style: type.bodyLarge.copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.w600, height: 1.2),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: type.bodyLarge.copyWith(color: colors.mutedText, fontWeight: FontWeight.w500, height: 1.2),
                filled: false,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (active && controller.text.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClear,
              child: SizedBox(width: 40, height: 40, child: Icon(AppIcons.close_rounded, size: 18, color: colors.mutedText)),
            ),
        ],
      ),
    );
  }
}

class _ChooseOnMapRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ChooseOnMapRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return PressableScale(
      pressedScale: 0.98,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                child: Icon(AppIcons.map_fill, size: 18, color: colors.navy),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700)),
              ),
              Icon(AppIcons.chevron_right, size: 16, color: colors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final PlaceLocation place;
  final double distanceKm;
  final bool recent;
  final String removeTooltip;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _PlaceTile({
    required this.place,
    required this.distanceKm,
    required this.recent,
    required this.removeTooltip,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final rest = place.address.contains(',') ? place.address.substring(place.address.indexOf(',') + 1).trim() : place.address;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
              child: Icon(recent ? AppIcons.clock_history : AppIcons.geo_alt_fill, size: 18, color: colors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoScrollText(place.shortName, style: type.label.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 1),
                  AutoScrollText(rest, style: type.caption.copyWith(color: colors.secondaryText)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('${distanceKm.toStringAsFixed(1)} km', style: type.caption.copyWith(color: colors.mutedText)),
            if (onRemove != null)
              IconButton(
                icon: Icon(AppIcons.close_rounded, size: 18, color: colors.mutedText),
                tooltip: removeTooltip,
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }
}
