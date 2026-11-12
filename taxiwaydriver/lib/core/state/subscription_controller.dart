import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscription_repository.dart';

class SubscriptionController extends AsyncNotifier<SubscriptionSnapshot> {
  @override
  Future<SubscriptionSnapshot> build() {
    return ref.read(subscriptionRepositoryProvider).getSnapshot();
  }

  Future<bool> renewSubscription() async {
    final renewed = await AsyncValue.guard(() => ref.read(subscriptionRepositoryProvider).renew());
    if (renewed.hasError) return false;
    state = renewed;
    return true;
  }
}

final subscriptionControllerProvider = AsyncNotifierProvider<SubscriptionController, SubscriptionSnapshot>(
  SubscriptionController.new,
);
