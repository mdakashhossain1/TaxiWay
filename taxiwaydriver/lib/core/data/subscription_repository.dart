import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/subscription_plan.dart';

class SubscriptionSnapshot {
  final SubscriptionPlan plan;
  final PaymentSummary summary;
  final PaymentHistoryEntry history;

  const SubscriptionSnapshot({required this.plan, required this.summary, required this.history});
}

abstract class SubscriptionRepository {
  Future<SubscriptionSnapshot> getSnapshot();
  Future<SubscriptionSnapshot> renew();
}

class ApiSubscriptionRepositoryImpl implements SubscriptionRepository {
  @override
  Future<SubscriptionSnapshot> getSnapshot() async {
    final response = await ApiClient.instance.get('/driver/subscription');
    final data = response['data'] as Map<String, dynamic>;
    return SubscriptionSnapshot(
      plan: SubscriptionPlan.fromJson(data['subscription'] as Map<String, dynamic>),
      summary: PaymentSummary.fromJson(data['summary'] as Map<String, dynamic>),
      history: PaymentHistoryEntry.fromJson(data['latest_payment'] as Map<String, dynamic>?),
    );
  }

  @override
  Future<SubscriptionSnapshot> renew() async {
    await ApiClient.instance.post('/driver/subscription/renew');
    return getSnapshot();
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) => ApiSubscriptionRepositoryImpl());
