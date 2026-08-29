import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/place_repository.dart';
import '../data/vehicle_repository.dart';
import '../models/fare_breakdown.dart';
import '../models/place_location.dart';
import '../models/vehicle_category.dart';
import '../services/road_route_service.dart';
import '../utils/geo_utils.dart';

/// Working state for the Home screen — pickup/destination/vehicle
/// selection before a booking is actually created.
class BookingDraft {
  final PlaceLocation? pickup;
  final PlaceLocation? destination;
  final VehicleCategory? selectedCategory;
  final double distanceKm;
  final int etaMinutes;

  const BookingDraft({
    this.pickup,
    this.destination,
    this.selectedCategory,
    this.distanceKm = 0,
    this.etaMinutes = 0,
  });

  bool get hasRoute => pickup != null && destination != null;

  BookingDraft copyWith({
    PlaceLocation? pickup,
    PlaceLocation? destination,
    VehicleCategory? selectedCategory,
    double? distanceKm,
    int? etaMinutes,
  }) {
    return BookingDraft(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      distanceKm: distanceKm ?? this.distanceKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}

class BookingDraftController extends Notifier<BookingDraft> {
  final PlaceRepository _placeRepo;
  final VehicleRepository _vehicleRepo;
  BookingDraftController(this._placeRepo, this._vehicleRepo);

  @override
  BookingDraft build() {
    // Asynchronously detect and update with real hardware GPS location
    Future.microtask(() => refreshCurrentGpsLocation());
    return BookingDraft(pickup: _placeRepo.currentLocation);
  }

  Future<void> refreshCurrentGpsLocation() async {
    final live = await _placeRepo.fetchExactCurrentLocation();
    if (state.pickup == null || state.pickup == _placeRepo.currentLocation) {
      setPickup(live);
    }
  }

  void setPickup(PlaceLocation location) {
    _placeRepo.updateCurrentLocation(location);
    state = state.copyWith(pickup: location);
    _recalculateRoute();
  }

  void setDestination(PlaceLocation location) {
    state = state.copyWith(destination: location);
    _recalculateRoute();
  }

  void selectCategory(VehicleCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void _recalculateRoute() {
    if (state.pickup == null || state.destination == null) return;
    
    // Quick initial estimate for instant feedback
    final directKm = haversineKm(state.pickup!, state.destination!);
    final initialKm = (directKm * 1.25).clamp(1.5, 90.0);
    final initialEta = ((initialKm / 28.0) * 60).round().clamp(4, 180);
    state = state.copyWith(distanceKm: initialKm, etaMinutes: initialEta);

    // Asynchronously resolve the exact turn-by-turn road driving distance and duration
    final start = LatLng(state.pickup!.latitude, state.pickup!.longitude);
    final end = LatLng(state.destination!.latitude, state.destination!.longitude);

    RoadRouteService.instance.fetchRealRoadRoute(start, end).then((routeResult) {
      if (state.pickup != null && state.destination != null) {
        state = state.copyWith(
          distanceKm: routeResult.distanceKm,
          etaMinutes: routeResult.durationMinutes,
        );
      }
    });
  }

  FareBreakdown? fareFor(VehicleCategory category) {
    if (!state.hasRoute) return null;
    return _vehicleRepo.estimateFare(category, state.distanceKm, state.etaMinutes);
  }

  void reset() {
    state = BookingDraft(pickup: _placeRepo.currentLocation);
  }
}
