import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxiway/core/geo/nearby_drivers.dart';

void main() {
  final now = DateTime(2026, 11, 12, 10);

  Map<String, dynamic> doc({bool available = true, Duration age = Duration.zero, double? lat = 25.6, double? lng = 85.1}) {
    return {
      'available': available,
      'lat': lat,
      'lng': lng,
      'driverHeading': 90.0,
      'updatedAt': Timestamp.fromDate(now.subtract(age)),
    };
  }

  test('a fresh available driver is shown with position and heading', () {
    final driver = nearbyDriverFrom('d1', doc(), now);

    expect(driver, isNotNull);
    expect(driver!.id, 'd1');
    expect(driver.lat, 25.6);
    expect(driver.heading, 90.0);
  });

  test('a driver on a trip is never shown as bookable', () {
    expect(nearbyDriverFrom('d1', doc(available: false), now), isNull);
  });

  test('a driver who stopped reporting ages out after the staleness window', () {
    expect(nearbyDriverFrom('d1', doc(age: const Duration(seconds: 89)), now), isNotNull);
    expect(nearbyDriverFrom('d1', doc(age: const Duration(seconds: 91)), now), isNull);
  });

  test('a parked driver kept alive every 45-50 seconds is still shown', () {
    expect(nearbyDriverFrom('d1', doc(age: const Duration(seconds: 50)), now), isNotNull);
  });

  test('a document without coordinates is ignored', () {
    expect(nearbyDriverFrom('d1', doc(lat: null), now), isNull);
    expect(nearbyDriverFrom('d1', doc(lng: null), now), isNull);
  });

  test('the listener is capped so a busy area cannot flood a rider', () {
    expect(maxNearbyDrivers, lessThanOrEqualTo(30), reason: 'also stays within Firestore whereIn/limit expectations');
  });
}
