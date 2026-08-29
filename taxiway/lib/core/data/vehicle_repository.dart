import '../api/api_client.dart';
import '../models/fare_breakdown.dart';
import '../models/vehicle_category.dart';

abstract class VehicleRepository {
  Future<List<VehicleCategory>> getCategories();
  FareBreakdown estimateFare(VehicleCategory category, double distanceKm, int etaMinutes);
}

class ApiVehicleRepository implements VehicleRepository {
  @override
  Future<List<VehicleCategory>> getCategories() async {
    final response = await ApiClient.instance.get('/vehicle-categories', auth: false);
    final list = response['data'] as List;
    return list.map((e) => VehicleCategory.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Pure arithmetic on the category's own (real, backend-sourced) rates —
  /// no need to round-trip to the server every time the route/distance
  /// changes while the customer is still adjusting their trip on Home.
  @override
  FareBreakdown estimateFare(VehicleCategory category, double distanceKm, int etaMinutes) {
    final distanceFare = distanceKm * category.perKmRate;
    final estimate = FareBreakdown(
      baseFare: category.baseFare,
      distanceFare: distanceFare,
      timeFare: 0,
    );
    if (estimate.total < category.minimumFare) {
      return FareBreakdown(
        baseFare: category.minimumFare,
        distanceFare: 0,
        timeFare: 0,
      );
    }
    return estimate;
  }
}
