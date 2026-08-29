import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/driver_ride.dart';

abstract class RideRepository {
  Future<DriverRide?> getNextRide();
  Future<DriverRide?> getPendingOffer();
  Future<DriverRide> getRide(String rideId);
  Future<List<DriverRide>> getRides({required String status});
  Future<DriverRide> markCompleted(String rideId);
  Future<DriverRide> acceptRide(String rideId);
  Future<void> rejectRide(String rideId);
}

class ApiRideRepositoryImpl implements RideRepository {
  @override
  Future<DriverRide?> getNextRide() async {
    final response = await ApiClient.instance.get('/driver/dashboard');
    final nextRide = (response['data'] as Map<String, dynamic>)['next_ride'];
    if (nextRide == null) return null;
    return DriverRide.fromJson(nextRide as Map<String, dynamic>);
  }

  @override
  Future<DriverRide?> getPendingOffer() async {
    final response = await ApiClient.instance.get('/driver/dashboard');
    final offer = (response['data'] as Map<String, dynamic>)['pending_offer'];
    if (offer == null) return null;
    return DriverRide.fromJson(offer as Map<String, dynamic>);
  }

  @override
  Future<DriverRide> getRide(String rideId) async {
    final response = await ApiClient.instance.get('/driver/rides/$rideId');
    return DriverRide.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<DriverRide>> getRides({required String status}) async {
    final response = await ApiClient.instance.get('/driver/rides?status=$status');
    final list = response['data'] as List;
    return list.map((e) => DriverRide.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DriverRide> markCompleted(String rideId) async {
    final response = await ApiClient.instance.post('/driver/rides/$rideId/mark-completed');
    return DriverRide.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<DriverRide> acceptRide(String rideId) async {
    final response = await ApiClient.instance.post('/driver/rides/$rideId/accept');
    return DriverRide.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> rejectRide(String rideId) async {
    await ApiClient.instance.post('/driver/rides/$rideId/reject');
  }
}

final rideRepositoryProvider = Provider<RideRepository>((ref) => ApiRideRepositoryImpl());
