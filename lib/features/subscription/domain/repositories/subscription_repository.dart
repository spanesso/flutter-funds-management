import '../entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getActiveSubscriptions();
  Future<void> createSubscription(Subscription subscription);
  Future<void> cancelSubscription(int fundId);
}
