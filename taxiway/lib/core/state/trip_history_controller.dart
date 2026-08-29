import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/trip_history_item.dart';

class TripHistoryController extends AsyncNotifier<List<TripHistoryItem>> {
  @override
  Future<List<TripHistoryItem>> build() async {
    final response = await ApiClient.instance.get('/customer/bookings');
    final list = response['data'] as List;
    return list.map((e) => TripHistoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
