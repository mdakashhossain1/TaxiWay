import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ride_repository.dart';
import '../models/driver_ride.dart';

/// The soonest active (accepted) ride, shown on the Dashboard.
final nextRideProvider = FutureProvider.autoDispose<DriverRide?>((ref) {
  return ref.watch(rideRepositoryProvider).getNextRide();
});

/// A ride offered to this driver that they haven't yet accepted/rejected —
/// surfaces an outstanding offer if the app was reopened after a push was
/// missed (permission denied, app killed before it arrived, etc.).
final pendingOfferProvider = FutureProvider.autoDispose<DriverRide?>((ref) {
  return ref.watch(rideRepositoryProvider).getPendingOffer();
});

final upcomingRidesProvider = FutureProvider.autoDispose<List<DriverRide>>((ref) {
  return ref.watch(rideRepositoryProvider).getRides(status: 'upcoming');
});

final completedRidesProvider = FutureProvider.autoDispose<List<DriverRide>>((ref) {
  return ref.watch(rideRepositoryProvider).getRides(status: 'completed');
});

/// Mutating actions live on their own notifier so the read-only list
/// providers above can stay simple FutureProviders that just refetch
/// whenever this invalidates them.
class RideActionsController extends Notifier<void> {
  @override
  void build() {}

  Future<DriverRide> markCompleted(String rideId) async {
    final updated = await ref.read(rideRepositoryProvider).markCompleted(rideId);
    ref.invalidate(nextRideProvider);
    ref.invalidate(upcomingRidesProvider);
    ref.invalidate(completedRidesProvider);
    return updated;
  }

  Future<DriverRide> acceptRide(String rideId) async {
    final updated = await ref.read(rideRepositoryProvider).acceptRide(rideId);
    ref.invalidate(pendingOfferProvider);
    ref.invalidate(nextRideProvider);
    ref.invalidate(upcomingRidesProvider);
    return updated;
  }

  Future<void> rejectRide(String rideId) async {
    await ref.read(rideRepositoryProvider).rejectRide(rideId);
    ref.invalidate(pendingOfferProvider);
  }
}

final rideActionsProvider = NotifierProvider<RideActionsController, void>(RideActionsController.new);
