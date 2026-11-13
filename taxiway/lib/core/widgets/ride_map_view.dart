import 'dart:math' as math;
import 'dart:ui' as ui;

import '../theme/app_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../l10n/generated/app_localizations.dart';
import '../models/booking.dart';
import '../models/place_location.dart';
import '../services/road_route_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../theme/dark_map_style.dart';
import '../utils/geo_utils.dart';

const kMapFallbackCenter = LatLng(25.5980, 85.1280);

class RideMapView extends StatefulWidget {
  final PlaceLocation? pickup;
  final PlaceLocation? destination;
  final bool showDestination;
  final bool showDriver;
  final MapDriverPhase driverPhase;
  final double driverProgress;

  /// The driver's real GPS position from the live trip channel. When set, the
  /// marker glides between these real coordinates (heading taken from the
  /// direction of travel); [driverProgress] is only the fallback used to
  /// interpolate along the route before the first fix or in the simulation.
  final LatLng? driverPosition;
  final VoidCallback? onRecenter;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final double? distanceKm;
  final int? etaMinutes;
  final bool enableExpand;
  final ValueChanged<LatLng>? onMapTap;
  final bool interactive;

  /// Ambient nearby available drivers to show as car markers (e.g. the home
  /// screen's "cars near you"). Independent of [showDriver], which tracks the
  /// one assigned driver on an active trip.
  final List<LatLng> nearbyDrivers;

  const RideMapView({
    super.key,
    this.pickup,
    this.destination,
    this.showDestination = false,
    this.showDriver = false,
    this.driverPhase = MapDriverPhase.approachingPickup,
    this.driverProgress = 0,
    this.driverPosition,
    this.onRecenter,
    this.height = 240,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.distanceKm,
    this.etaMinutes,
    this.enableExpand = true,
    this.onMapTap,
    this.interactive = true,
    this.nearbyDrivers = const [],
  });

  @override
  State<RideMapView> createState() => _RideMapViewState();
}

class _RideMapViewState extends State<RideMapView> with SingleTickerProviderStateMixin {
  GoogleMapController? _controller;
  bool _fitted = false;
  bool _isExpanded = false;
  BitmapDescriptor? _carIcon;
  bool _carIconRequested = false;

  // Driver-marker smoothing: the `driverProgress` prop updates in coarse steps
  // (a live GPS fix every few seconds, or a 1 Hz simulation tick), which makes
  // the car jump. Instead of drawing the prop value directly, we tween a
  // _displayedProgress toward it at 60fps so the car glides — the same reason
  // Uber's car feels alive.
  late final AnimationController _driverAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..addListener(() => setState(() {}));
  double _animFrom = 0;
  double _animTo = 0;

  double get _driverProgress =>
      _animFrom + (_animTo - _animFrom) * _driverAnimation.value;

  void _animateDriverTo(double target) {
    _animFrom = _driverProgress;
    _animTo = target.clamp(0.0, 1.0);
    _driverAnimation.forward(from: 0);
  }

  LatLng? _liveFrom;
  LatLng? _liveTo;
  double _liveBearing = 0;

  LatLng? get _livePosition {
    final to = _liveTo;
    if (to == null) return null;
    final from = _liveFrom ?? to;
    final t = _driverAnimation.value;
    return LatLng(
      from.latitude + (to.latitude - from.latitude) * t,
      from.longitude + (to.longitude - from.longitude) * t,
    );
  }

  void _animateLiveTo(LatLng target) {
    final current = _livePosition;
    _liveFrom = current ?? target;
    _liveTo = target;
    final from = _liveFrom!;
    final movedMeters = math.sqrt(
          math.pow(target.latitude - from.latitude, 2) + math.pow(target.longitude - from.longitude, 2),
        ) *
        111000;
    if (movedMeters > 3) {
      _liveBearing = RoadRouteService.instance.calculateBearing(from, target);
    }
    _driverAnimation.forward(from: 0);
  }

  LatLng get _pickupLatLng => widget.pickup != null
      ? LatLng(widget.pickup!.latitude, widget.pickup!.longitude)
      : kMapFallbackCenter;

  LatLng? get _destinationLatLng => widget.destination != null
      ? LatLng(widget.destination!.latitude, widget.destination!.longitude)
      : null;

  List<LatLng>? _liveRoutePoints;
  Set<Polyline> _polylines = const {};
  Object? _polylineKey;

  @override
  void initState() {
    super.initState();
    _animFrom = _animTo = widget.driverProgress;
    _liveFrom = _liveTo = widget.driverPosition;
    _loadLiveRoadRoute();
  }

  @override
  void dispose() {
    _driverAnimation.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_carIconRequested) {
      _carIconRequested = true;
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      _buildCarIcon(devicePixelRatio).then((icon) {
        if (mounted) setState(() => _carIcon = icon);
      });
    }
  }

  /// Draws a simple top-down car marker (colored body + windshield, on a
  /// white halo for contrast against any map style) pointing north — the
  /// marker's own `rotation` then turns it to face the direction of travel.
  Future<BitmapDescriptor> _buildCarIcon(double devicePixelRatio) async {
    const logicalSize = 52.0;
    final size = logicalSize * devicePixelRatio;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));
    final cx = size / 2;
    final cy = size / 2;
    final w = size * 0.38;
    final h = size * 0.78;
    final top = cy - h / 2;
    final bottom = cy + h / 2;
    final left = cx - w / 2;
    final right = cx + w / 2;

    final body = Path()
      ..moveTo(cx, top)
      ..cubicTo(right - w * 0.05, top, right, top + h * 0.10, right, top + h * 0.24)
      ..lineTo(right, bottom - h * 0.20)
      ..cubicTo(right, bottom - h * 0.04, right - w * 0.12, bottom, cx, bottom)
      ..cubicTo(left + w * 0.12, bottom, left, bottom - h * 0.04, left, bottom - h * 0.20)
      ..lineTo(left, top + h * 0.24)
      ..cubicTo(left, top + h * 0.10, left + w * 0.05, top, cx, top)
      ..close();

    canvas.drawPath(
      body.shift(Offset(0, size * 0.025)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.30)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 0.045),
    );
    canvas.drawPath(
      body,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.05
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF273449), Color(0xFF0B1220)],
        ).createShader(Rect.fromLTRB(left, top, right, bottom)),
    );

    void glass(double centerY, double widthFactor, double heightFactor, Color color) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, centerY), width: w * widthFactor, height: h * heightFactor),
          Radius.circular(w * 0.14),
        ),
        Paint()..color = color,
      );
    }

    glass(cy - h * 0.12, 0.80, 0.19, const Color(0xFF9DB4D3));
    glass(cy + h * 0.08, 0.74, 0.25, const Color(0xFF3B4A63));
    glass(cy + h * 0.29, 0.72, 0.10, const Color(0xFF7F95B5));

    final headlight = Paint()..color = const Color(0xFFFDE68A);
    final taillight = Paint()..color = const Color(0xFFEF4444);
    for (final dx in [-w * 0.27, w * 0.27]) {
      canvas.drawCircle(Offset(cx + dx, top + h * 0.075), w * 0.075, headlight);
      canvas.drawCircle(Offset(cx + dx, bottom - h * 0.055), w * 0.07, taillight);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.round(), size.round());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List(), width: logicalSize, height: logicalSize);
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

  LatLng _positionAtProgress(double progress) {
    if (widget.driverPhase == MapDriverPhase.approachingPickup) {
      final approach = _driverApproachPoints;
      if (approach.isEmpty) return _pickupLatLng;
      return RoadRouteService.instance.interpolateAlongPath(approach, 1 - progress);
    }
    final route = _routePoints;
    if (route.isEmpty) return _pickupLatLng;
    return RoadRouteService.instance.interpolateAlongPath(route, progress);
  }

  LatLng? get _driverLatLng {
    if (!widget.showDriver) return null;
    return _livePosition ?? _positionAtProgress(_driverProgress);
  }

  /// Compass bearing the car icon should point in, sampled just behind/ahead
  /// of the current progress so it stays correct through both map-view
  /// phases (the approach phase runs its progress backwards over the path).
  double? get _driverHeading {
    if (!widget.showDriver) return null;
    if (_liveTo != null) return _liveBearing;
    const delta = 0.02;
    final behind = (_driverProgress - delta).clamp(0.0, 1.0);
    final ahead = (_driverProgress + delta).clamp(0.0, 1.0);
    if (behind == ahead) return null;
    final p1 = _positionAtProgress(behind);
    final p2 = _positionAtProgress(ahead);
    if (p1.latitude == p2.latitude && p1.longitude == p2.longitude) return null;
    return RoadRouteService.instance.calculateBearing(p1, p2);
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
    final newPosition = widget.driverPosition;
    if (widget.showDriver && newPosition != null && newPosition != oldWidget.driverPosition) {
      _animateLiveTo(newPosition);
      _followDriver();
    } else if (widget.showDriver &&
        newPosition == null &&
        (oldWidget.driverProgress - widget.driverProgress).abs() > 0.001) {
      _animateDriverTo(widget.driverProgress);
      _followDriver();
    }
  }

  double? _followZoomLevel;
  bool _establishingZoom = false;

  Future<void> _followDriver() async {
    final controller = _controller;
    if (controller == null || !widget.showDriver) return;
    // Lead the camera to where the car is heading (the target) while the marker
    // glides there, so the two settle together instead of the camera lagging.
    final driver = widget.driverPosition ?? _positionAtProgress(widget.driverProgress);
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

  Set<Polyline> _buildPolylines(List<LatLng> route, Color primary) {
    return {
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
          color: primary,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final driver = _driverLatLng;
    final destination = widget.showDestination ? _destinationLatLng : null;
    final route = _routePoints;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: widget.pickup?.shortName ?? l10n.pickupLabel),
      ),
      if (destination != null)
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: widget.destination?.shortName ?? l10n.destinationLabel),
        ),
      if (driver != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: driver,
          icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
          rotation: _driverHeading ?? 0,
          flat: true,
          zIndexInt: 3,
          infoWindow: InfoWindow(title: l10n.driverLocationLabel),
        ),
      for (var i = 0; i < widget.nearbyDrivers.length; i++)
        Marker(
          markerId: MarkerId('nearby_$i'),
          position: widget.nearbyDrivers[i],
          icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          zIndexInt: 2,
        ),
    };

    final primary = AppColors.of(context).primary;
    final polylineKey = Object.hash(identityHashCode(_liveRoutePoints), widget.showDriver, widget.driverPhase, primary);
    if (polylineKey != _polylineKey) {
      _polylineKey = polylineKey;
      _polylines = _buildPolylines(route, primary);
    }
    final polylines = _polylines;

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
            color: const Color(0xFF101114).withValues(alpha: 0.10),
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
                style: Theme.of(context).brightness == Brightness.dark ? kDarkMapStyle : null,
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
                    color: AppColors.of(context).card,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.of(context).border, width: 1),
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
                      Icon(AppIcons.car_front_fill, size: 14, color: AppColors.of(context).primary),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n.kmShort(widget.distanceKm!.toStringAsFixed(1))} • ${l10n.minutesShort(widget.etaMinutes!)}',
                        style: AppTypography.of(context).caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).navy,
                          fontSize: 13,
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
                  color: AppColors.of(context).card,
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
                            _isExpanded ? AppIcons.fullscreen_exit : AppIcons.arrows_fullscreen,
                            size: 15,
                            color: AppColors.of(context).navy,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isExpanded ? l10n.collapseMapLabel : l10n.expandMapLabel,
                            style: AppTypography.of(context).caption.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.of(context).navy,
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

/// The booking's live driver coordinate as a map position, or null before the
/// first GPS fix arrives from the trip channel.
LatLng? driverPositionOf(Booking booking) {
  final lat = booking.driverLat;
  final lng = booking.driverLng;
  return lat == null || lng == null ? null : LatLng(lat, lng);
}

class _RecenterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RecenterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.of(context).card,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(AppIcons.crosshair, size: 18, color: AppColors.of(context).navy),
        ),
      ),
    );
  }
}
