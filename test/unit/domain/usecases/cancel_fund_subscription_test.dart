import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:investment_funds_app/core/errors/business_errors.dart';
import 'package:investment_funds_app/core/result/result.dart';
import 'package:investment_funds_app/features/funds/domain/entities/fund.dart';
import 'package:investment_funds_app/features/subscription/domain/entities/subscription.dart';
import 'package:investment_funds_app/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:investment_funds_app/features/subscription/domain/usecases/cancel_fund_subscription.dart';
import 'package:investment_funds_app/features/transactions/domain/entities/transaction.dart';
import 'package:investment_funds_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:investment_funds_app/features/wallet/domain/entities/wallet.dart';
import 'package:investment_funds_app/features/wallet/domain/repositories/wallet_repository.dart';

class MockWalletRepository extends Mock implements WalletRepository {}
class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockSubscriptionRepository subscriptionRepo;
  late MockWalletRepository walletRepo;
  late MockTransactionRepository transactionRepo;
  late CancelFundSubscription useCase;

  final testDate = DateTime(2025, 3, 25, 14, 30);

  late Subscription activeSubscription;

  setUpAll(() {
    registerFallbackValue(
      Transaction(
        id: 'tx-id',
        type: TransactionType.cancellation,
        fundId: 1,
        fundName: 'FPV_PACTUAL_RECAUDADORA',
        category: FundCategory.fpv,
        amount: 100000,
        createdAt: testDate,
      ),
    );
  });

  setUp(() {
    subscriptionRepo = MockSubscriptionRepository();
    walletRepo = MockWalletRepository();
    transactionRepo = MockTransactionRepository();

    useCase = CancelFundSubscription(
      subscriptionRepository: subscriptionRepo,
      walletRepository: walletRepo,
      transactionRepository: transactionRepo,
    );

    activeSubscription = Subscription(
      id: 'sub-001',
      fundId: 1,
      fundName: 'FPV_PACTUAL_RECAUDADORA',
      category: FundCategory.fpv,
      subscribedAmount: 100000,
      subscribedAt: testDate,
      notificationMethod: NotificationMethod.email,
      isActive: true,
    );

    when(() => subscriptionRepo.getActiveSubscriptions())
        .thenAnswer((_) async => [activeSubscription]);
    when(() => subscriptionRepo.cancelSubscription(any()))
        .thenAnswer((_) async {});
    when(() => walletRepo.getWallet())
        .thenAnswer((_) async => const Wallet(availableBalance: 400000));
    when(() => walletRepo.updateBalance(any()))
        .thenAnswer((_) async {});
    when(() => transactionRepo.addTransaction(any()))
        .thenAnswer((_) async {});
  });

  group('CancelFundSubscription', () {
    test('happy path — cancels subscription and reintegrates balance', () async {
      final result = await useCase(
        const CancelFundSubscriptionInput(fundId: 1),
      );

      expect(result, isA<Success<void>>());
      verify(() => subscriptionRepo.cancelSubscription(1)).called(1);
      // Balance: 400000 + 100000 = 500000
      verify(() => walletRepo.updateBalance(500000)).called(1);
      verify(() => transactionRepo.addTransaction(any())).called(1);
    });

    test('subscription not found — returns SubscriptionNotFoundError', () async {
      when(() => subscriptionRepo.getActiveSubscriptions())
          .thenAnswer((_) async => []);

      final result = await useCase(
        const CancelFundSubscriptionInput(fundId: 1),
      );

      expect(result, isA<Failure<void>>());
      expect((result as Failure<void>).error, isA<SubscriptionNotFoundError>());
      verifyNever(() => walletRepo.updateBalance(any()));
      verifyNever(() => transactionRepo.addTransaction(any()));
    });

    test('cancellation creates a transaction of type cancellation', () async {
      await useCase(const CancelFundSubscriptionInput(fundId: 1));

      final captured =
          verify(() => transactionRepo.addTransaction(captureAny())).captured;
      final tx = captured.first as Transaction;
      expect(tx.type, TransactionType.cancellation);
      expect(tx.fundId, 1);
      expect(tx.amount, 100000);
      expect(tx.notificationMethod, isNull);
    });

    test('balance is correctly reintegrated — 400000 + 100000 = 500000',
        () async {
      await useCase(const CancelFundSubscriptionInput(fundId: 1));
      verify(() => walletRepo.updateBalance(500000)).called(1);
    });
  });
}
