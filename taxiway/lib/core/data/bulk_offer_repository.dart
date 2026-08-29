import '../models/bulk_booking.dart';

abstract class BulkOfferRepository {
  BulkOffer buildOffer({required int numVehicles, required double totalFare, required Set<String> requirements});
}

/// A small pool of mock driver/vehicle combinations so a bulk offer with
/// several vehicles doesn't just repeat the single default driver.
class MockBulkOfferRepository implements BulkOfferRepository {
  static const _pool = [
    BulkOfferVehicle(
      driverName: 'Amit Kumar',
      rating: 4.8,
      totalTrips: 230,
      verified: true,
      vehicleModel: 'White Swift Dzire',
      registrationNumber: 'BR01PA1234',
      category: 'Sedan',
      seats: 3,
      ac: true,
      fareShare: 0,
    ),
    BulkOfferVehicle(
      driverName: 'Suresh Yadav',
      rating: 4.6,
      totalTrips: 180,
      verified: true,
      vehicleModel: 'Toyota Innova',
      registrationNumber: 'BR01PB5678',
      category: 'SUV',
      seats: 7,
      ac: true,
      fareShare: 0,
    ),
    BulkOfferVehicle(
      driverName: 'Ravi Singh',
      rating: 4.7,
      totalTrips: 145,
      verified: true,
      vehicleModel: 'Force Traveller',
      registrationNumber: 'BR01PC9012',
      category: 'Traveller',
      seats: 8,
      ac: true,
      fareShare: 0,
    ),
    BulkOfferVehicle(
      driverName: 'Manoj Kumar',
      rating: 4.9,
      totalTrips: 310,
      verified: true,
      vehicleModel: 'Maruti Ertiga',
      registrationNumber: 'BR01PD3456',
      category: 'SUV',
      seats: 7,
      ac: true,
      fareShare: 0,
    ),
  ];

  @override
  BulkOffer buildOffer({required int numVehicles, required double totalFare, required Set<String> requirements}) {
    final count = numVehicles.clamp(1, _pool.length);
    final share = totalFare / count;
    final vehicles = List.generate(count, (i) {
      final base = _pool[i % _pool.length];
      return BulkOfferVehicle(
        driverName: base.driverName,
        rating: base.rating,
        totalTrips: base.totalTrips,
        verified: base.verified,
        vehicleModel: base.vehicleModel,
        registrationNumber: base.registrationNumber,
        category: base.category,
        seats: base.seats,
        ac: requirements.contains('AC') || !requirements.contains('Non-AC'),
        fareShare: share,
      );
    });

    return BulkOffer(
      id: 'OF${DateTime.now().millisecondsSinceEpoch}',
      vehicles: vehicles,
      totalFare: totalFare,
      includedCharges: const {'Driver Allowance', 'Fuel Charges', 'Toll Tax', 'Parking Charges'},
      validUntil: DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
