import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscription_repository.dart';

class SubscriptionController extends AsyncNotifier<SubscriptionSnapshot> {
  @override
  Future<SubscriptionSnapshot> build() {
    return ref.read(subscriptionRepositoryProvider).getSnapshot();
  }

  Future<void> renewSubscription() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(subscriptionRepositoryProvider).renew());
  }
}

final subscriptionControllerProvider = AsyncNotifierProvider<SubscriptionController, SubscriptionSnapshot>(
  SubscriptionController.new,
);
