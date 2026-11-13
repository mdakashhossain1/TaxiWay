import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/road_route_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';
import 'osm_tile_layer.dart';

/// Pickup to destination route on a map, with the driver's own live position.
class OfferRouteMap extends StatefulWidget {
  final LatLng pickup;
  final LatLng destination;

  const OfferRouteMap({super.key, required this.pickup, required this.destination});

  @override
  State<OfferRouteMap> createState() => _OfferRouteMapState();
}

class _OfferRouteMapState extends State<OfferRouteMap> {
  final MapController _map = MapController();
  RoadRoute? _route;
  LatLng? _driver;
  StreamSubscription<Position>? _positionSub;
  bool _ready = false;
  bool _fitted = false;

  @override
  void initState() {
    super.initState();
    RoadRouteService.instance.fetch(widget.pickup, widget.destination).then((route) {
      if (!mounted) return;
      setState(() => _route = route);
      _fit();
    });
    _watchDriver();
  }

  Future<void> _watchDriver() async {
    final first = await determineCurrentPosition();
    if (!mounted) return;
    if (first != null) {
      setState(() => _driver = LatLng(first.latitude, first.longitude));
    }
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((position) {
      if (mounted) setState(() => _driver = LatLng(position.latitude, position.longitude));
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _map.dispose();
    super.dispose();
  }

  bool _includeDriver = false;

  void _fit() {
    if (!_ready) return;
    final points = <LatLng>[
      ...(_route?.points ?? [widget.pickup, widget.destination]),
      if (_includeDriver && _driver != null) _driver!,
    ];
    var minLat = points.first.latitude, maxLat = minLat;
    var minLng = points.first.longitude, maxLng = minLng;
    for (final p in points) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    const pad = 0.002;
    _map.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat - pad, minLng - pad), LatLng(maxLat + pad, maxLng + pad)),
        padding: const EdgeInsets.all(40),
        maxZoom: 16,
      ),
    );
    _fitted = true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final route = _route;

    return Stack(
      children: [
        FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: widget.pickup,
            initialZoom: 14,
            minZoom: 3,
            maxZoom: 19,
            backgroundColor: colors.surface,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
            onMapReady: () {
              _ready = true;
              _fit();
            },
          ),
          children: [
            const OsmTileLayer(),
            if (route != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route.points,
                    strokeWidth: 5,
                    color: colors.mapRoute,
                    borderStrokeWidth: 2,
                    borderColor: colors.card,
                    strokeCap: StrokeCap.round,
                    strokeJoin: StrokeJoin.round,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(point: widget.pickup, width: 28, height: 28, child: _StopDot(color: colors.mapPickup, ring: colors.card)),
                Marker(
                  point: widget.destination,
                  width: 28,
                  height: 28,
                  child: _StopDot(color: colors.mapDestination, ring: colors.card, square: true),
                ),
                if (_driver != null) Marker(point: _driver!, width: 40, height: 40, child: _DriverDot(color: colors.info, ring: colors.card)),
              ],
            ),
            const OsmAttribution(),
          ],
        ),
        if (route?.distanceKm != null && route?.durationMinutes != null)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 3))],
              ),
              child: Text(
                '${route!.distanceKm!.toStringAsFixed(1)} km · ${route.durationMinutes} min',
                style: type.caption.copyWith(fontWeight: FontWeight.w700, color: colors.navy, fontSize: 13),
              ),
            ),
          ),
        if (_fitted)
          Positioned(
            right: 12,
            bottom: 12,
            child: Material(
              color: colors.card,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  _includeDriver = _driver != null && !_includeDriver;
                  _fit();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(AppIcons.arrows_fullscreen, size: 20, color: colors.navy),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StopDot extends StatelessWidget {
  final Color color;
  final Color ring;
  final bool square;

  const _StopDot({required this.color, required this.ring, this.square = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: square ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: square ? BorderRadius.circular(4) : null,
          border: Border.all(color: ring, width: 3),
          boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
      ),
    );
  }
}

class _DriverDot extends StatelessWidget {
  final Color color;
  final Color ring;

  const _DriverDot({required this.color, required this.ring});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle)),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: ring, width: 3)),
        ),
      ],
    );
  }
}
