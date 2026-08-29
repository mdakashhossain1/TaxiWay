import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bulk_booking.dart';
import '../models/place_location.dart';
import '../services/road_route_service.dart';

/// Working state for Bulk Booking steps 1-2 (Trip & Capacity, Additional
/// Requirements) before the request is actually submitted.
class BulkBookingDraft {
  final BulkTripType tripType;
  final PlaceLocation? pickup;
  final PlaceLocation? destination;
  final DateTime? journeyDate;
  final String? journeyTime;
  final int numVehicles;
  final int approxPassengers;
  final Set<String> requirements;
  final String notes;
  final String contactName;
  final String contactPhone;
  final double? distanceKm;
  final int? etaMinutes;

  const BulkBookingDraft({
    this.tripType = BulkTripType.oneWay,
    this.pickup,
    this.destination,
    this.journeyDate,
    this.journeyTime,
    this.numVehicles = 2,
    this.approxPassengers = 10,
    this.requirements = const {},
    this.notes = '',
    this.contactName = '',
    this.contactPhone = '',
    this.distanceKm,
    this.etaMinutes,
  });

  bool get step1Valid => pickup != null && destination != null && journeyDate != null && journeyTime != null;
  bool get step2Valid => contactName.trim().isNotEmpty && contactPhone.trim().length == 10;

  BulkBookingDraft copyWith({
    BulkTripType? tripType,
    PlaceLocation? pickup,
    PlaceLocation? destination,
    DateTime? journeyDate,
    String? journeyTime,
    int? numVehicles,
    int? approxPassengers,
    Set<String>? requirements,
    String? notes,
    String? contactName,
    String? contactPhone,
    double? distanceKm,
    int? etaMinutes,
  }) {
    return BulkBookingDraft(
      tripType: tripType ?? this.tripType,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      journeyDate: journeyDate ?? this.journeyDate,
      journeyTime: journeyTime ?? this.journeyTime,
      numVehicles: numVehicles ?? this.numVehicles,
      approxPassengers: approxPassengers ?? this.approxPassengers,
      requirements: requirements ?? this.requirements,
      notes: notes ?? this.notes,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      distanceKm: distanceKm ?? this.distanceKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}

class BulkBookingDraftController extends Notifier<BulkBookingDraft> {
  @override
  BulkBookingDraft build() => const BulkBookingDraft();

  void setTripType(BulkTripType t) => state = state.copyWith(tripType: t);

  Future<void> setPickup(PlaceLocation p) async {
    state = state.copyWith(pickup: p);
    await _recalculateRoute();
  }

  Future<void> setDestination(PlaceLocation d) async {
    state = state.copyWith(destination: d);
    await _recalculateRoute();
  }

  Future<void> _recalculateRoute() async {
    if (state.pickup != null && state.destination != null) {
      final route = await RoadRouteService.instance.fetchRealRoadRoute(
        LatLng(state.pickup!.latitude, state.pickup!.longitude),
        LatLng(state.destination!.latitude, state.destination!.longitude),
      );
      state = state.copyWith(
        distanceKm: route.distanceKm,
        etaMinutes: route.durationMinutes,
      );
    }
  }

  void setJourneyDate(DateTime d) => state = state.copyWith(journeyDate: d);
  void setJourneyTime(String t) => state = state.copyWith(journeyTime: t);
  void setNumVehicles(int n) => state = state.copyWith(numVehicles: n.clamp(1, 20));
  void setApproxPassengers(int n) => state = state.copyWith(approxPassengers: n.clamp(1, 200));
  void toggleRequirement(String r) {
    final next = Set<String>.from(state.requirements);
    if (!next.remove(r)) next.add(r);
    state = state.copyWith(requirements: next);
  }

  void setNotes(String n) => state = state.copyWith(notes: n);
  void setContactName(String n) => state = state.copyWith(contactName: n);
  void setContactPhone(String p) => state = state.copyWith(contactPhone: p);

  void reset() => state = const BulkBookingDraft();
}
