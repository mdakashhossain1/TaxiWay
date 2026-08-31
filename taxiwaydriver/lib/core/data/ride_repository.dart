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

  /// Scheduled rides open to any eligible driver — first to accept wins.
  Future<List<DriverRide>> getScheduledRides();
  Future<DriverRide> acceptScheduledRide(String rideId);
  Future<void> declineScheduledRide(String rideId);
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

  @override
  Future<List<DriverRide>> getScheduledRides() async {
    final response = await ApiClient.instance.get('/driver/scheduled-rides');
    final list = response['data'] as List;
    return list.map((e) => DriverRide.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DriverRide> acceptScheduledRide(String rideId) async {
    // Can throw ApiException(422, 'This ride has already been accepted by
    // another driver.') — the message is meant to be shown as-is, not
    // treated as a generic failure; see ScheduledRideDetailScreen.
    final response = await ApiClient.instance.post('/driver/scheduled-rides/$rideId/accept');
    return DriverRide.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> declineScheduledRide(String rideId) async {
    await ApiClient.instance.post('/driver/scheduled-rides/$rideId/decline');
  }
}

final rideRepositoryProvider = Provider<RideRepository>((ref) => ApiRideRepositoryImpl());
