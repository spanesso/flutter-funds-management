import '../../../../datasource/mock_datasource.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  const SubscriptionRepositoryImpl(this._datasource);
  final MockDatasource _datasource;

  @override
  Future<List<Subscription>> getActiveSubscriptions() =>
      _datasource.getActiveSubscriptions();

  @override
  Future<void> createSubscription(Subscription subscription) =>
      _datasource.createSubscription(subscription);

  @override
  Future<void> cancelSubscription(int fundId) =>
      _datasource.cancelSubscription(fundId);
}
