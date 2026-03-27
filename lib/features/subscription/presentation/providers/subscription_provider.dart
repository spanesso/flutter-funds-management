import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../datasource/mock_datasource.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/usecases/cancel_fund_subscription.dart';
import '../../domain/usecases/get_active_subscriptions.dart';
import '../../domain/usecases/subscribe_to_fund.dart';
import '../../../funds/presentation/providers/funds_provider.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final datasource = ref.watch(mockDatasourceProvider);
  return SubscriptionRepositoryImpl(datasource);
});

final getActiveSubscriptionsProvider = Provider<GetActiveSubscriptions>((ref) {
  return GetActiveSubscriptions(ref.watch(subscriptionRepositoryProvider));
});

final subscribeToFundProvider = Provider<SubscribeToFund>((ref) {
  return SubscribeToFund(
    fundRepository: ref.watch(fundRepositoryProvider),
    walletRepository: ref.watch(walletRepositoryProvider),
    subscriptionRepository: ref.watch(subscriptionRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

final cancelFundSubscriptionProvider = Provider<CancelFundSubscription>((ref) {
  return CancelFundSubscription(
    subscriptionRepository: ref.watch(subscriptionRepositoryProvider),
    walletRepository: ref.watch(walletRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});
