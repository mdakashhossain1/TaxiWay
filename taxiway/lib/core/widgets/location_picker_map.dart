import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';

import '../data/nominatim_client.dart';
import '../models/place_location.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/geo_utils.dart';
import 'osm_tile_layer.dart';
import 'ride_map_view.dart' show kMapFallbackCenter;

/// Interactive map used to manually pick a pickup/destination: a pin stays
/// fixed at screen center while the user drags the map under it, and the
/// pin's coordinates are reverse-geocoded into an address once the camera
/// settles. Exposes [animateTo] and [useCurrentLocation] via its state so a
/// parent screen (e.g. tapping a search result) can drive it too.
class LocationPickerMap extends StatefulWidget {
  final PlaceLocation? initial;
  final ValueChanged<PlaceLocation> onLocationChanged;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const LocationPickerMap({
    super.key,
    this.initial,
    required this.onLocationChanged,
    this.height = 220,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<LocationPickerMap> createState() => LocationPickerMapState();
}

class LocationPickerMapState extends State<LocationPickerMap> {
  static const _storage = FlutterSecureStorage();
  static const _localeKey = 'app_locale_code';

  final MapController _map = MapController();
  late LatLng _center;
  bool _ready = false;
  bool _moving = false;
  Timer? _settleTimer;

  Future<String> _currentLocaleCode() async => (await _storage.read(key: _localeKey)) ?? 'en';

  @override
  void initState() {
    super.initState();
    _center = widget.initial != null
        ? LatLng(widget.initial!.latitude, widget.initial!.longitude)
        : kMapFallbackCenter;
    WidgetsBinding.instance.addPostFrameCallback((_) => useCurrentLocation());
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    _map.dispose();
    super.dispose();
  }

  /// Moves the pin/camera to a known place (e.g. a tapped search result).
  Future<void> animateTo(PlaceLocation place) async {
    final target = LatLng(place.latitude, place.longitude);
    setState(() => _center = target);
    if (_ready) _map.move(target, 16);
    widget.onLocationChanged(place);
  }

  /// Moves the pin/camera to the device's current GPS position, then
  /// reverse-geocodes it like any other drag.
  Future<void> useCurrentLocation() async {
    final position = await determineCurrentPosition();
    if (position == null || !mounted) return;
    final target = LatLng(position.latitude, position.longitude);
    setState(() => _center = target);
    if (_ready) _map.move(target, 16);
    await _reverseGeocode();
  }

  Future<void> _reverseGeocode() async {
    final at = _center;
    String address;
    try {
      final localeCode = await _currentLocaleCode();
      final displayName = await nominatimReverseGeocode(at.latitude, at.longitude, localeCode);
      address = displayName ?? '${at.latitude.toStringAsFixed(5)}, ${at.longitude.toStringAsFixed(5)}';
    } catch (_) {
      address = '${at.latitude.toStringAsFixed(5)}, ${at.longitude.toStringAsFixed(5)}';
    }
    if (!mounted || at != _center) return;
    widget.onLocationChanged(PlaceLocation(latitude: at.latitude, longitude: at.longitude, address: address));
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    _center = camera.center;
    if (!hasGesture) return;
    if (!_moving) setState(() => _moving = true);
    _settleTimer?.cancel();
    _settleTimer = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() => _moving = false);
      _reverseGeocode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 16,
                minZoom: 3,
                maxZoom: 19,
                backgroundColor: colors.surface,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.flingAnimation,
                ),
                onMapReady: () => _ready = true,
                onPositionChanged: _onPositionChanged,
              ),
              children: const [OsmTileLayer(), OsmAttribution()],
            ),
            IgnorePointer(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: _moving ? 14 : 9,
                    height: _moving ? 5 : 3.5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedSlide(
                    offset: _moving ? const Offset(0, -0.2) : Offset.zero,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 44),
                      child: Icon(
                        AppIcons.geo_alt_fill,
                        size: 48,
                        color: colors.navy,
                        shadows: const [Shadow(color: Color(0x33000000), blurRadius: 5, offset: Offset(0, 2))],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(right: 12, bottom: 12, child: _RecenterFab(onTap: useCurrentLocation)),
          ],
        ),
      ),
    );
  }
}

class _RecenterFab extends StatelessWidget {
  final VoidCallback onTap;
  const _RecenterFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.of(context).card,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(AppIcons.crosshair, size: 20, color: AppColors.of(context).navy),
        ),
      ),
    );
  }
}
