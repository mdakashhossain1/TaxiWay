import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_location.dart';
import '../theme/app_colors.dart';
import '../utils/geo_utils.dart';
import 'ride_map_view.dart' show kMapFallbackCenter;

/// Real, interactive Google Map used to manually pick a pickup/destination:
/// a pin stays fixed at screen center while the user drags the map under it,
/// and the pin's coordinates are reverse-geocoded into an address once the
/// camera settles. Exposes [animateTo] and [useCurrentLocation] via its
/// state so a parent screen (e.g. tapping a search result) can drive it too.
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
  GoogleMapController? _controller;
  final _geocoding = geocoding.Geocoding();
  late LatLng _center;
  bool _moving = false;

  @override
  void initState() {
    super.initState();
    _center = widget.initial != null
        ? LatLng(widget.initial!.latitude, widget.initial!.longitude)
        : kMapFallbackCenter;
  }

  /// Moves the pin/camera to a known place (e.g. a tapped search result).
  Future<void> animateTo(PlaceLocation place) async {
    final target = LatLng(place.latitude, place.longitude);
    setState(() => _center = target);
    await _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    widget.onLocationChanged(place);
  }

  /// Moves the pin/camera to the device's current GPS position, then
  /// reverse-geocodes it like any other drag.
  Future<void> useCurrentLocation() async {
    final position = await determineCurrentPosition();
    if (position == null || !mounted) return;
    final target = LatLng(position.latitude, position.longitude);
    setState(() => _center = target);
    await _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    await _reverseGeocode();
  }

  Future<void> _reverseGeocode() async {
    final at = _center;
    String address;
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(at.latitude, at.longitude);
      if (placemarks.isEmpty) {
        address = '${at.latitude.toStringAsFixed(5)}, ${at.longitude.toStringAsFixed(5)}';
      } else {
        final p = placemarks.first;
        final isPlusCode = p.name != null && p.name!.contains('+');
        final parts = <String>{
          if (p.name != null && p.name!.isNotEmpty && !isPlusCode) p.name!,
          if (p.street != null && p.street!.isNotEmpty && p.street != p.name && !p.street!.contains('+')) p.street!,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea!,
        }.toList();
        address = parts.isNotEmpty ? parts.join(', ') : '${at.latitude.toStringAsFixed(5)}, ${at.longitude.toStringAsFixed(5)}';
      }
    } catch (_) {
      // Geocoding API unavailable/offline — fall back to raw coordinates.
      address = '${at.latitude.toStringAsFixed(5)}, ${at.longitude.toStringAsFixed(5)}';
    }
    if (!mounted || at != _center) return;
    widget.onLocationChanged(PlaceLocation(latitude: at.latitude, longitude: at.longitude, address: address));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _center, zoom: 16),
              onMapCreated: (controller) => _controller = controller,
              onCameraMoveStarted: () => setState(() => _moving = true),
              onCameraMove: (position) => _center = position.target,
              onCameraIdle: () {
                setState(() => _moving = false);
                _reverseGeocode();
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
            IgnorePointer(
              child: AnimatedSlide(
                offset: _moving ? const Offset(0, -0.12) : Offset.zero,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Icon(
                    BootstrapIcons.geo_alt_fill,
                    size: 38,
                    color: AppColors.mapDestination,
                    shadows: [Shadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2))],
                  ),
                ),
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
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(BootstrapIcons.crosshair, size: 20, color: AppColors.navy),
        ),
      ),
    );
  }
}
