/// Integration test: full subscription and cancellation flow.
///
/// Tests the complete round-trip:
/// subscribe → verify balance deduction → verify portfolio → verify history
/// → cancel → verify balance reintegration
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:investment_funds_app/core/constants/app_constants.dart';
import 'package:investment_funds_app/core/result/result.dart';
import 'package:investment_funds_app/datasource/mock_datasource.dart';
import 'package:investment_funds_app/features/funds/data/repositories/fund_repository_impl.dart';
import 'package:investment_funds_app/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:investment_funds_app/features/subscription/domain/entities/subscription.dart';
import 'package:investment_funds_app/features/subscription/domain/usecases/cancel_fund_subscription.dart';
import 'package:investment_funds_app/features/subscription/domain/usecases/get_active_subscriptions.dart';
import 'package:investment_funds_app/features/subscription/domain/usecases/subscribe_to_fund.dart';
import 'package:investment_funds_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:investment_funds_app/features/transactions/domain/entities/transaction.dart';
import 'package:investment_funds_app/features/transactions/domain/usecases/get_transactions_history.dart';
import 'package:investment_funds_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:investment_funds_app/features/wallet/domain/entities/wallet.dart';
import 'package:investment_funds_app/features/wallet/domain/usecases/get_wallet_balance.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDatasource datasource;
  late SubscribeToFund subscribeUseCase;
  late CancelFundSubscription cancelUseCase;
  late GetWalletBalance getBalance;
  late GetActiveSubscriptions getSubscriptions;
  late GetTransactionsHistory getHistory;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    datasource = MockDatasource();
    await datasource.reset();

    final fundRepo = FundRepositoryImpl(datasource);
    final walletRepo = WalletRepositoryImpl(datasource);
    final subRepo = SubscriptionRepositoryImpl(datasource);
    final txRepo = TransactionRepositoryImpl(datasource);

    subscribeUseCase = SubscribeToFund(
      fundRepository: fundRepo,
      walletRepository: walletRepo,
      subscriptionRepository: subRepo,
      transactionRepository: txRepo,
    );

    cancelUseCase = CancelFundSubscription(
      subscriptionRepository: subRepo,
      walletRepository: walletRepo,
      transactionRepository: txRepo,
    );

    getBalance = GetWalletBalance(walletRepo);
    getSubscriptions = GetActiveSubscriptions(subRepo);
    getHistory = GetTransactionsHistory(txRepo);
  });

  test('Full flow: subscribe → check balance → check portfolio → check history → cancel → reintegrate',
      () async {
    // 1. Verify initial balance is COP 500.000
    final initialBalance = await getBalance();
    expect(initialBalance, isA<Success>());
    expect((initialBalance as Success).data.availableBalance,
        AppConstants.initialBalance);

    // 2. Subscribe to fund 1 with COP 100.000
    const subscribeInput = SubscribeToFundInput(
      fundId: 1,
      amount: 100000,
      notificationMethod: NotificationMethod.email,
    );
    final subscribeResult = await subscribeUseCase(subscribeInput);
    expect(subscribeResult, isA<Success<Subscription>>());

    // 3. Verify balance was deducted: 500.000 - 100.000 = 400.000
    final balanceAfterSub = await getBalance();
    expect((balanceAfterSub as Success).data.availableBalance, 400000.0);

    // 4. Verify portfolio has 1 active subscription
    final portfolioResult = await getSubscriptions();
    expect(portfolioResult, isA<Success<List<Subscription>>>());
    final subs = (portfolioResult as Success<List<Subscription>>).data;
    expect(subs.length, 1);
    expect(subs.first.fundId, 1);
    expect(subs.first.isActive, true);
    expect(subs.first.subscribedAmount, 100000);

    // 5. Verify transaction history has 1 subscription record
    final historyResult = await getHistory();
    expect(historyResult, isA<Success<List<Transaction>>>());
    final history = (historyResult as Success<List<Transaction>>).data;
    expect(history.length, 1);
    expect(history.first.type, TransactionType.subscription);
    expect(history.first.amount, 100000);

    // 6. Cancel the subscription
    final cancelResult = await cancelUseCase(
      const CancelFundSubscriptionInput(fundId: 1),
    );
    expect(cancelResult, isA<Success<void>>());

    // 7. Verify balance was reintegrated: 400.000 + 100.000 = 500.000
    final balanceAfterCancel = await getBalance();
    expect(
      (balanceAfterCancel as Success).data.availableBalance,
      AppConstants.initialBalance,
    );

    // 8. Verify portfolio is now empty
    final portfolioAfterCancel = await getSubscriptions();
    expect(
      (portfolioAfterCancel as Success<List<Subscription>>).data,
      isEmpty,
    );

    // 9. Verify history has 2 records: subscription + cancellation (ordered DESC)
    final historyAfterCancel = await getHistory();
    final finalHistory =
        (historyAfterCancel as Success<List<Transaction>>).data;
    expect(finalHistory.length, 2);
    // DESC order: cancellation first, subscription second
    expect(finalHistory[0].type, TransactionType.cancellation);
    expect(finalHistory[1].type, TransactionType.subscription);
  });

  test('Cannot subscribe to same fund twice — DuplicateSubscriptionError', () async {
    await subscribeUseCase(const SubscribeToFundInput(
      fundId: 1,
      amount: 100000,
      notificationMethod: NotificationMethod.sms,
    ));

    final secondResult = await subscribeUseCase(const SubscribeToFundInput(
      fundId: 1,
      amount: 100000,
      notificationMethod: NotificationMethod.email,
    ));

    expect(secondResult, isA<Failure>());
    expect(secondResult.errorOrThrow.userMessage,
        contains('participación activa'));
  });

  test('Balance never goes negative after failed subscription', () async {
    // Attempt with more than available balance
    await subscribeUseCase(const SubscribeToFundInput(
      fundId: 4, // minimum 250000
      amount: 600000, // more than 500000 initial balance
      notificationMethod: NotificationMethod.email,
    ));

    final balance = await getBalance();
    final successBalance = balance as Success<Wallet>;
    expect(
      successBalance.data.availableBalance,
      greaterThanOrEqualTo(0),
    );
    // Balance must remain 500000 (unchanged)
    expect(successBalance.data.availableBalance, AppConstants.initialBalance);
  });
}
