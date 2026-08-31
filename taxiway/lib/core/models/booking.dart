import 'driver.dart';
import 'fare_breakdown.dart';
import 'place_location.dart';
import 'vehicle.dart';
import 'vehicle_category.dart';

/// Booking status model (PRD §72).
enum BookingStatus {
  draft,
  requested,
  allocating,
  scheduledOpen,
  driverOffered,
  driverAssigned,
  driverEnRoute,
  driverArrived,
  rideStarted,
  rideInProgress,
  completed,
  cancelled,
  failed,
}

extension BookingStatusX on BookingStatus {
  bool get isActive => this != BookingStatus.completed &&
      this != BookingStatus.cancelled &&
      this != BookingStatus.failed &&
      this != BookingStatus.draft;
}

BookingStatus _statusFromApi(String status) {
  switch (status) {
    case 'requested':
      return BookingStatus.requested;
    case 'allocating':
      return BookingStatus.allocating;
    case 'scheduled_open':
      return BookingStatus.scheduledOpen;
    case 'driver_offered':
      return BookingStatus.driverOffered;
    case 'driver_assigned':
      return BookingStatus.driverAssigned;
    case 'driver_en_route':
      return BookingStatus.driverEnRoute;
    case 'driver_arrived':
      return BookingStatus.driverArrived;
    case 'ride_started':
      return BookingStatus.rideStarted;
    case 'ride_in_progress':
      return BookingStatus.rideInProgress;
    case 'completed':
      return BookingStatus.completed;
    case 'cancelled':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.failed;
  }
}

class Booking {
  final String id;
  final PlaceLocation pickup;
  final PlaceLocation destination;
  final VehicleCategory vehicleCategory;
  final double distanceKm;
  final int etaMinutes;
  final FareBreakdown fare;
  final BookingStatus status;
  final String driverId;
  final DateTime createdAt;
  final String paymentMethod;
  final String paymentStatus;

  /// 'instant' (book now) or 'scheduled' (booked ahead of time via
  /// [scheduledAt]). Scheduled rides skip the client-side driver-approach
  /// simulation on assignment — see BookingController.applyDriverAccepted.
  final String type;
  final DateTime? scheduledAt;

  bool get isScheduled => type == 'scheduled';

  /// The real driver/vehicle allocated to this booking by the backend —
  /// null only in the brief window (or edge case) before/if allocation
  /// hasn't happened yet.
  final Driver? driver;
  final Vehicle? vehicle;

  /// Live simulation fields for tracking screens. These are a cosmetic,
  /// client-side approximation of the driver's approach (no real GPS feed
  /// exists) — see BookingController for the full rationale.
  final double driverDistanceKm;
  final int driverEtaMinutes;
  final double routeProgress; // 0.0 - 1.0 while ride is in progress

  const Booking({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.vehicleCategory,
    required this.distanceKm,
    required this.etaMinutes,
    required this.fare,
    required this.status,
    required this.driverId,
    required this.createdAt,
    this.paymentMethod = 'Cash / UPI',
    this.paymentStatus = 'Paid',
    this.type = 'instant',
    this.scheduledAt,
    this.driver,
    this.vehicle,
    this.driverDistanceKm = 0,
    this.driverEtaMinutes = 0,
    this.routeProgress = 0,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>;
    final driverJson = json['driver'] as Map<String, dynamic>?;
    final vehicleJson = json['vehicle'] as Map<String, dynamic>?;
    final categoryName = categoryJson['name'] as String;

    return Booking(
      id: json['id'].toString(),
      pickup: PlaceLocation(
        latitude: double.parse(json['pickup_lat'].toString()),
        longitude: double.parse(json['pickup_lng'].toString()),
        address: json['pickup_address'] as String,
      ),
      destination: PlaceLocation(
        latitude: double.parse(json['destination_lat'].toString()),
        longitude: double.parse(json['destination_lng'].toString()),
        address: json['destination_address'] as String,
      ),
      vehicleCategory: VehicleCategory.fromJson(categoryJson),
      distanceKm: double.parse(json['distance_km'].toString()),
      etaMinutes: json['eta_minutes'] as int,
      fare: FareBreakdown.fromJson(json),
      status: _statusFromApi(json['status'] as String),
      driverId: json['driver_id']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      paymentMethod: (json['payment_method'] as String).toUpperCase(),
      paymentStatus: json['payment_status'] == 'paid' ? 'Paid' : 'Pending',
      type: json['type'] as String? ?? 'instant',
      scheduledAt: json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at'] as String).toLocal() : null,
      driver: driverJson != null ? Driver.fromJson(driverJson) : null,
      vehicle: vehicleJson != null ? Vehicle.fromJson(vehicleJson, categoryName: categoryName, seats: categoryJson['seats'] as int, ac: categoryJson['ac'] as bool) : null,
    );
  }

  Booking copyWith({
    BookingStatus? status,
    double? driverDistanceKm,
    int? driverEtaMinutes,
    double? routeProgress,
    String? paymentStatus,
    Driver? driver,
    Vehicle? vehicle,
  }) {
    return Booking(
      id: id,
      pickup: pickup,
      destination: destination,
      vehicleCategory: vehicleCategory,
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      fare: fare,
      status: status ?? this.status,
      driverId: driverId,
      createdAt: createdAt,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      type: type,
      scheduledAt: scheduledAt,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      driverDistanceKm: driverDistanceKm ?? this.driverDistanceKm,
      driverEtaMinutes: driverEtaMinutes ?? this.driverEtaMinutes,
      routeProgress: routeProgress ?? this.routeProgress,
    );
  }
}
