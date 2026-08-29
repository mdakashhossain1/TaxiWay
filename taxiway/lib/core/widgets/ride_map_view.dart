import 'dart:math' as math;

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_location.dart';
import '../services/road_route_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';

const kMapFallbackCenter = LatLng(25.5980, 85.1280);

class RideMapView extends StatefulWidget {
  final PlaceLocation? pickup;
  final PlaceLocation? destination;
  final bool showDestination;
  final bool showDriver;
  final MapDriverPhase driverPhase;
  final double driverProgress;
  final VoidCallback? onRecenter;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final double? distanceKm;
  final int? etaMinutes;
  final bool enableExpand;
  final ValueChanged<LatLng>? onMapTap;
  final bool interactive;

  const RideMapView({
    super.key,
    this.pickup,
    this.destination,
    this.showDestination = false,
    this.showDriver = false,
    this.driverPhase = MapDriverPhase.approachingPickup,
    this.driverProgress = 0,
    this.onRecenter,
    this.height = 240,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.distanceKm,
    this.etaMinutes,
    this.enableExpand = true,
    this.onMapTap,
    this.interactive = true,
  });

  @override
  State<RideMapView> createState() => _RideMapViewState();
}

class _RideMapViewState extends State<RideMapView> {
  GoogleMapController? _controller;
  bool _fitted = false;
  bool _isExpanded = false;

  LatLng get _pickupLatLng => widget.pickup != null
      ? LatLng(widget.pickup!.latitude, widget.pickup!.longitude)
      : kMapFallbackCenter;

  LatLng? get _destinationLatLng => widget.destination != null
      ? LatLng(widget.destination!.latitude, widget.destination!.longitude)
      : null;

  List<LatLng>? _liveRoutePoints;

  @override
  void initState() {
    super.initState();
    _loadLiveRoadRoute();
  }

  void _loadLiveRoadRoute() {
    final dest = widget.showDestination ? _destinationLatLng : null;
    if (dest == null) {
      _liveRoutePoints = null;
      return;
    }

    RoadRouteService.instance.fetchRealRoadRoute(_pickupLatLng, dest).then((res) {
      if (mounted && res.points.isNotEmpty) {
        setState(() {
          _liveRoutePoints = res.points;
        });
        _fitCamera();
      }
    });
  }

  List<LatLng> get _routePoints => _liveRoutePoints ?? [];

  List<LatLng> get _driverApproachPoints => _liveRoutePoints != null && _liveRoutePoints!.length > 4
      ? _liveRoutePoints!.take((_liveRoutePoints!.length * 0.4).round()).toList()
      : [_pickupLatLng];

  LatLng? get _driverLatLng {
    if (!widget.showDriver) return null;
    if (widget.driverPhase == MapDriverPhase.approachingPickup) {
      final approach = _driverApproachPoints;
      if (approach.isEmpty) return _pickupLatLng;
      return RoadRouteService.instance.interpolateAlongPath(approach, 1 - widget.driverProgress);
    }
    final route = _routePoints;
    if (route.isEmpty) return _pickupLatLng;
    return RoadRouteService.instance.interpolateAlongPath(route, widget.driverProgress);
  }

  @override
  void didUpdateWidget(covariant RideMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showDestination != widget.showDestination ||
        oldWidget.destination != widget.destination ||
        oldWidget.pickup != widget.pickup ||
        oldWidget.driverPhase != widget.driverPhase) {
      _followZoomLevel = null;
      _loadLiveRoadRoute();
      _fitCamera();
      return;
    }
    if (widget.showDriver && (oldWidget.driverProgress - widget.driverProgress).abs() > 0.001) {
      _followDriver();
    }
  }

  double? _followZoomLevel;
  bool _establishingZoom = false;

  Future<void> _followDriver() async {
    final controller = _controller;
    final driver = _driverLatLng;
    if (controller == null || driver == null) return;
    final target = widget.driverPhase == MapDriverPhase.approachingPickup
        ? _pickupLatLng
        : (_destinationLatLng ?? _pickupLatLng);

    if (_followZoomLevel == null) {
      if (_establishingZoom) return;
      _establishingZoom = true;
      await controller.animateCamera(CameraUpdate.newLatLngBounds(_boundsFor([driver, target]), 60));
      _followZoomLevel = await controller.getZoomLevel();
      _establishingZoom = false;
      return;
    }

    await controller.animateCamera(CameraUpdate.newLatLngZoom(driver, _followZoomLevel!));
  }

  Future<void> _fitCamera() async {
    final controller = _controller;
    if (controller == null) return;
    final route = _routePoints;
    if (route.isNotEmpty) {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(_boundsFor(route), 45),
      );
    } else if (widget.showDestination && _destinationLatLng != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(_boundsFor([_pickupLatLng, _destinationLatLng!]), 50),
      );
    } else {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_pickupLatLng, 15.5),
      );
    }
  }

  LatLngBounds _boundsFor(List<LatLng> points) {
    var minLat = points.first.latitude, maxLat = points.first.latitude;
    var minLng = points.first.longitude, maxLng = points.first.longitude;
    for (final p in points.skip(1)) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    const epsilon = 0.003;
    if ((maxLat - minLat) < epsilon) {
      minLat -= epsilon;
      maxLat += epsilon;
    }
    if ((maxLng - minLng) < epsilon) {
      minLng -= epsilon;
      maxLng += epsilon;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _recenter() async {
    final position = await determineCurrentPosition();
    if (position != null && mounted) {
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 16),
      );
    }
    widget.onRecenter?.call();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    Future.delayed(const Duration(milliseconds: 340), () => _fitCamera());
  }

  @override
  Widget build(BuildContext context) {
    final driver = _driverLatLng;
    final destination = widget.showDestination ? _destinationLatLng : null;
    final route = _routePoints;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: widget.pickup?.shortName ?? 'Pickup'),
      ),
      if (destination != null)
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: widget.destination?.shortName ?? 'Destination'),
        ),
      if (driver != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: driver,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          zIndexInt: 3,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
    };

    final polylines = <Polyline>{
      if (widget.showDriver && widget.driverPhase == MapDriverPhase.approachingPickup)
        Polyline(
          polylineId: const PolylineId('driver_approach'),
          points: _driverApproachPoints,
          color: const Color(0xFF6366F1),
          width: 4,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      if (route.isNotEmpty) ...[
        Polyline(
          polylineId: const PolylineId('route_border'),
          points: route,
          color: const Color(0xFFC2410C),
          width: 7,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
        Polyline(
          polylineId: const PolylineId('route_main'),
          points: route,
          color: AppColors.primary,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      ],
    };

    final targetHeight = _isExpanded ? 540.0 : widget.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOutCubic,
      height: targetHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: !widget.interactive,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _pickupLatLng, zoom: 15.5),
                onMapCreated: (controller) {
                  _controller = controller;
                  if (!_fitted) {
                    _fitted = true;
                    _fitCamera();
                  }
                },
                markers: markers,
                polylines: polylines,
                onTap: widget.interactive ? widget.onMapTap : null,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: widget.interactive,
                zoomGesturesEnabled: widget.interactive,
                scrollGesturesEnabled: widget.interactive,
                rotateGesturesEnabled: widget.interactive,
                tiltGesturesEnabled: widget.interactive,
                gestureRecognizers: widget.interactive
                    ? <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      }
                    : const <Factory<OneSequenceGestureRecognizer>>{},
              ),
            ),

            if (widget.showDestination && widget.distanceKm != null && widget.etaMinutes != null)
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(BootstrapIcons.car_front_fill, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.distanceKm!.toStringAsFixed(1)} km • ${widget.etaMinutes} min',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (widget.enableExpand && widget.interactive)
              Positioned(
                top: 14,
                left: 14,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  elevation: 3,
                  shadowColor: Colors.black38,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    onTap: _toggleExpand,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isExpanded ? BootstrapIcons.fullscreen_exit : BootstrapIcons.arrows_fullscreen,
                            size: 15,
                            color: AppColors.navy,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isExpanded ? 'Collapse' : 'Full Screen',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            if (widget.onRecenter != null && widget.interactive)
              Positioned(
                right: 14,
                bottom: 14,
                child: _RecenterButton(onTap: _recenter),
              ),
          ],
        ),
      ),
    );
  }
}

enum MapDriverPhase { approachingPickup, headingToDestination }

class _RecenterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RecenterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(BootstrapIcons.crosshair, size: 18, color: AppColors.navy),
        ),
      ),
    );
  }
}
