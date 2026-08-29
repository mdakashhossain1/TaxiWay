enum DriverRideStatus { offered, upcoming, completed, cancelled }

enum RidePaymentStatus { paid, pending }

class DriverRide {
  final String id;
  final DateTime dateTime;
  final String pickup;
  final double pickupLat;
  final double pickupLng;
  final String destination;
  final double destinationLat;
  final double destinationLng;
  final String customerName;
  final String customerPhone;
  final String vehicleCategory;
  final double fare;
  final RidePaymentStatus paymentStatus;
  final DriverRideStatus status;

  /// Only set while [status] is [DriverRideStatus.offered] — when the offer
  /// countdown (server-enforced by `ExpireRideOffer`) runs out.
  final DateTime? offerExpiresAt;

  const DriverRide({
    required this.id,
    required this.dateTime,
    required this.pickup,
    required this.pickupLat,
    required this.pickupLng,
    required this.destination,
    required this.destinationLat,
    required this.destinationLng,
    required this.customerName,
    required this.customerPhone,
    required this.vehicleCategory,
    required this.fare,
    required this.paymentStatus,
    required this.status,
    this.offerExpiresAt,
  });

  factory DriverRide.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>;
    final category = json['category'] as Map<String, dynamic>;

    DriverRideStatus status;
    switch (json['status'] as String) {
      case 'driver_offered':
        status = DriverRideStatus.offered;
        break;
      case 'completed':
        status = DriverRideStatus.completed;
        break;
      case 'cancelled':
        status = DriverRideStatus.cancelled;
        break;
      default:
        status = DriverRideStatus.upcoming;
    }

    return DriverRide(
      offerExpiresAt: json['offer_expires_at'] != null ? DateTime.parse(json['offer_expires_at'] as String).toLocal() : null,
      id: json['id'].toString(),
      dateTime: DateTime.parse(json['created_at'] as String).toLocal(),
      pickup: json['pickup_address'] as String,
      pickupLat: double.parse(json['pickup_lat'].toString()),
      pickupLng: double.parse(json['pickup_lng'].toString()),
      destination: json['destination_address'] as String,
      destinationLat: double.parse(json['destination_lat'].toString()),
      destinationLng: double.parse(json['destination_lng'].toString()),
      customerName: customer['name'] as String,
      customerPhone: customer['phone'] as String,
      vehicleCategory: '${category['seats']} Seater',
      fare: double.parse(json['total_fare'].toString()),
      paymentStatus: json['payment_status'] == 'paid' ? RidePaymentStatus.paid : RidePaymentStatus.pending,
      status: status,
    );
  }

  DriverRide copyWith({DriverRideStatus? status, RidePaymentStatus? paymentStatus}) {
    return DriverRide(
      id: id,
      dateTime: dateTime,
      pickup: pickup,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destination: destination,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      customerName: customerName,
      customerPhone: customerPhone,
      vehicleCategory: vehicleCategory,
      fare: fare,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
    );
  }
}
