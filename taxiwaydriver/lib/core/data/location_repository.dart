import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

abstract class LocationRepository {
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    String? h3Index,
  });
}

class ApiLocationRepositoryImpl implements LocationRepository {
  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    String? h3Index,
  }) async {
    await ApiClient.instance.post(
      '/driver/location',
      body: {
        'latitude': latitude,
        'longitude': longitude,
        'h3_r8': ?h3Index,
      },
    );
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) => ApiLocationRepositoryImpl());
