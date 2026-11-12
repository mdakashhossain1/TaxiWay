import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taxiway/core/api/api_client.dart';
import 'package:taxiway/core/api/api_connectivity.dart';
import 'package:taxiway/core/api/native_secrets.dart';
import 'package:taxiway/core/api/network_failure.dart';
import 'package:taxiway/core/models/fare_breakdown.dart';
import 'package:taxiway/core/models/place_location.dart';
import 'package:taxiway/core/models/vehicle_category.dart';
import 'package:taxiway/core/providers.dart';
import 'package:taxiway/core/realtime/trip_channel.dart';

class _SilentChannel implements TripChannel {
  @override
  Stream<TripLiveUpdate> watch(String bookingId) => const Stream.empty();
}

const _pickup = PlaceLocation(latitude: 25.598, longitude: 85.128, address: 'Mithapur, Patna');
const _destination = PlaceLocation(latitude: 25.61, longitude: 85.14, address: 'Patna Junction');

VehicleCategory _category() => VehicleCategory.fromJson({
      'id': 3,
      'name': 'Sedan',
      'seats': 4,
      'ac': true,
      'base_fare': '100',
      'per_km_rate': '12',
    });

Map<String, dynamic> _bookingJson({
  String status = 'requested',
  DateTime? createdAt,
  double pickupLat = 25.598,
  int categoryId = 3,
}) {
  return {
    'id': 55,
    'vehicle_category_id': categoryId,
    'pickup_address': _pickup.address,
    'pickup_lat': '$pickupLat',
    'pickup_lng': '85.128',
    'destination_address': _destination.address,
    'destination_lat': '25.61',
    'destination_lng': '85.14',
    'distance_km': '3.2',
    'eta_minutes': 9,
    'base_fare': '100',
    'distance_charge': '38.4',
    'time_charge': '0',
    'status': status,
    'created_at': (createdAt ?? DateTime.now().toUtc()).toIso8601String(),
    'payment_method': 'cash',
    'payment_status': 'pending',
    'type': 'instant',
    'driver': null,
    'vehicle': null,
    'category': {
      'id': 3,
      'name': 'Sedan',
      'seats': 4,
      'ac': true,
      'base_fare': '100',
      'per_km_rate': '12',
    },
  };
}

void main() {
  late List<String> requests;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});
    await NativeSecrets.load();
  });

  setUp(() {
    requests = [];
    ApiConnectivity.status.value = NetworkStatus.online;
    ApiClient.instance.retryDelays = const [Duration.zero, Duration.zero];
    ApiClient.instance.requestTimeout = const Duration(milliseconds: 150);
  });

  ProviderContainer containerWith({
    required Future<http.Response> Function(http.Request request) onPost,
    required List<Map<String, dynamic>> existingBookings,
  }) {
    ApiClient.instance.client = MockClient((request) {
      requests.add('${request.method} ${request.url.path}');
      if (request.method == 'POST') return onPost(request);
      return Future.value(http.Response(jsonEncode({'data': existingBookings}), 200));
    });
    final container = ProviderContainer(overrides: [tripChannelProvider.overrideWithValue(_SilentChannel())]);
    addTearDown(container.dispose);
    return container;
  }

  Future<dynamic> create(ProviderContainer container) {
    return container.read(bookingControllerProvider.notifier).createBooking(
          pickup: _pickup,
          destination: _destination,
          vehicleCategory: _category(),
          distanceKm: 3.2,
          etaMinutes: 9,
          fare: const FareBreakdown(baseFare: 100, distanceFare: 38.4, timeFare: 0),
        );
  }

  test('a timed-out booking that the server did create is adopted, not duplicated', () async {
    final container = containerWith(
      onPost: (_) => Completer<http.Response>().future,
      existingBookings: [_bookingJson()],
    );

    final booking = await create(container);

    expect(booking.id, '55');
    expect(container.read(bookingControllerProvider)?.id, '55');
    expect(requests.where((r) => r.startsWith('POST')).length, 1, reason: 'never posts a second booking');
  });

  test('a timed-out booking with no match still reports the timeout', () async {
    final container = containerWith(onPost: (_) => Completer<http.Response>().future, existingBookings: []);

    await expectLater(create(container), throwsA(isA<NetworkFailure>()));
    expect(container.read(bookingControllerProvider), isNull);
  });

  test('an old, a cancelled or a different booking is not adopted', () async {
    final container = containerWith(
      onPost: (_) => Completer<http.Response>().future,
      existingBookings: [
        _bookingJson(createdAt: DateTime.now().toUtc().subtract(const Duration(minutes: 30))),
        _bookingJson(status: 'cancelled'),
        _bookingJson(pickupLat: 26.2),
        _bookingJson(categoryId: 9),
      ],
    );

    await expectLater(create(container), throwsA(isA<NetworkFailure>()));
  });

  test('going offline is not ambiguous, so it never goes looking for a booking', () async {
    final container = containerWith(
      onPost: (_) async => throw http.ClientException('no route to host'),
      existingBookings: [_bookingJson()],
    );

    await expectLater(
      create(container),
      throwsA(isA<NetworkFailure>().having((e) => e.kind, 'kind', NetworkFailureKind.offline)),
    );
    expect(requests, ['POST /api/customer/bookings']);
  });
}
