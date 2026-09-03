import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

abstract class LocationRepository {
  Future<void> updateLocation({required double latitude, required double longitude});
}

class ApiLocationRepositoryImpl implements LocationRepository {
  @override
  Future<void> updateLocation({required double latitude, required double longitude}) async {
    await ApiClient.instance.post(
      '/driver/location',
      body: {'latitude': latitude, 'longitude': longitude},
    );
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) => ApiLocationRepositoryImpl());
