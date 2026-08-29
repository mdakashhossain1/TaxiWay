import 'place_location.dart';

enum BulkTripType { oneWay, roundTrip }

/// Simplified subset of PRD §73's bulk status model, covering the request
/// flow through confirmation (this phase doesn't simulate the actual
/// multi-vehicle ride execution — PRD's flow ends at "Final Booking").
enum BulkBookingStatus { submitted, underReview, offerReady, confirmed, cancelled }

const List<String> kBulkRequirementOptions = [
  'AC',
  'Non-AC',
  'Luggage Space',
  'Driver with Uniform',
  'Toll Included',
  'Music System',
];

class BulkBookingRequest {
  final String id;
  final BulkTripType tripType;
  final PlaceLocation pickup;
  final PlaceLocation destination;
  final DateTime journeyDate;
  final String journeyTime;
  final int numVehicles;
  final int approxPassengers;
  final Set<String> requirements;
  final String notes;
  final String contactName;
  final String contactPhone;
  final double estimatedFareMin;
  final double estimatedFareMax;
  final BulkBookingStatus status;
  final DateTime createdAt;

  const BulkBookingRequest({
    required this.id,
    required this.tripType,
    required this.pickup,
    required this.destination,
    required this.journeyDate,
    required this.journeyTime,
    required this.numVehicles,
    required this.approxPassengers,
    required this.requirements,
    required this.notes,
    required this.contactName,
    required this.contactPhone,
    required this.estimatedFareMin,
    required this.estimatedFareMax,
    required this.status,
    required this.createdAt,
  });

  BulkBookingRequest copyWith({BulkBookingStatus? status}) {
    return BulkBookingRequest(
      id: id,
      tripType: tripType,
      pickup: pickup,
      destination: destination,
      journeyDate: journeyDate,
      journeyTime: journeyTime,
      numVehicles: numVehicles,
      approxPassengers: approxPassengers,
      requirements: requirements,
      notes: notes,
      contactName: contactName,
      contactPhone: contactPhone,
      estimatedFareMin: estimatedFareMin,
      estimatedFareMax: estimatedFareMax,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class BulkOfferVehicle {
  final String driverName;
  final double rating;
  final int totalTrips;
  final bool verified;
  final String vehicleModel;
  final String registrationNumber;
  final String category;
  final int seats;
  final bool ac;
  final double fareShare;

  const BulkOfferVehicle({
    required this.driverName,
    required this.rating,
    required this.totalTrips,
    required this.verified,
    required this.vehicleModel,
    required this.registrationNumber,
    required this.category,
    required this.seats,
    required this.ac,
    required this.fareShare,
  });
}

class BulkOffer {
  final String id;
  final List<BulkOfferVehicle> vehicles;
  final double totalFare;
  final Set<String> includedCharges;
  final DateTime validUntil;

  const BulkOffer({
    required this.id,
    required this.vehicles,
    required this.totalFare,
    required this.includedCharges,
    required this.validUntil,
  });

  int get totalCapacity => vehicles.fold(0, (sum, v) => sum + v.seats);
}
