import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:investment_funds_app/core/errors/business_errors.dart';
import 'package:investment_funds_app/core/result/result.dart';
import 'package:investment_funds_app/features/funds/domain/entities/fund.dart';
import 'package:investment_funds_app/features/funds/domain/repositories/fund_repository.dart';
import 'package:investment_funds_app/features/subscription/domain/entities/subscription.dart';
import 'package:investment_funds_app/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:investment_funds_app/features/subscription/domain/usecases/subscribe_to_fund.dart';
import 'package:investment_funds_app/features/transactions/domain/entities/transaction.dart';
import 'package:investment_funds_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:investment_funds_app/features/wallet/domain/entities/wallet.dart';
import 'package:investment_funds_app/features/wallet/domain/repositories/wallet_repository.dart';

class MockFundRepository extends Mock implements FundRepository {}
class MockWalletRepository extends Mock implements WalletRepository {}
class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockFundRepository fundRepo;
  late MockWalletRepository walletRepo;
  late MockSubscriptionRepository subscriptionRepo;
  late MockTransactionRepository transactionRepo;
  late SubscribeToFund useCase;

  const testFund = Fund(
    id: 1,
    name: 'FPV_PACTUAL_RECAUDADORA',
    category: FundCategory.fpv,
    minimumAmount: 75000,
  );

  const testWallet = Wallet(availableBalance: 500000);
  final testDate = DateTime(2025, 3, 25, 14, 30);

  setUpAll(() {
    registerFallbackValue(
      Subscription(
        id: 'test-id',
        fundId: 1,
        fundName: 'FPV_PACTUAL_RECAUDADORA',
        category: FundCategory.fpv,
        subscribedAmount: 100000,
        subscribedAt: testDate,
        notificationMethod: NotificationMethod.email,
        isActive: true,
      ),
    );
    registerFallbackValue(
      Transaction(
        id: 'tx-id',
        type: TransactionType.subscription,
        fundId: 1,
        fundName: 'FPV_PACTUAL_RECAUDADORA',
        category: FundCategory.fpv,
        amount: 100000,
        createdAt: testDate,
      ),
    );
  });

  setUp(() {
    fundRepo = MockFundRepository();
    walletRepo = MockWalletRepository();
    subscriptionRepo = MockSubscriptionRepository();
    transactionRepo = MockTransactionRepository();

    useCase = SubscribeToFund(
      fundRepository: fundRepo,
      walletRepository: walletRepo,
      subscriptionRepository: subscriptionRepo,
      transactionRepository: transactionRepo,
    );

    when(() => fundRepo.getAvailableFunds())
        .thenAnswer((_) async => [testFund]);
    when(() => walletRepo.getWallet())
        .thenAnswer((_) async => testWallet);
    when(() => subscriptionRepo.getActiveSubscriptions())
        .thenAnswer((_) async => []);
    when(() => subscriptionRepo.createSubscription(any()))
        .thenAnswer((_) async {});
    when(() => walletRepo.updateBalance(any()))
        .thenAnswer((_) async {});
    when(() => transactionRepo.addTransaction(any()))
        .thenAnswer((_) async {});
  });

  group('SubscribeToFund', () {
    test('happy path — creates subscription and deducts balance', () async {
      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Success<Subscription>>());
      final sub = (result as Success<Subscription>).data;
      expect(sub.fundId, 1);
      expect(sub.subscribedAmount, 100000);
      expect(sub.isActive, true);
      expect(sub.notificationMethod, NotificationMethod.email);

      verify(() => walletRepo.updateBalance(400000)).called(1);
      verify(() => subscriptionRepo.createSubscription(any())).called(1);
      verify(() => transactionRepo.addTransaction(any())).called(1);
    });

    test('invalid amount — returns InvalidAmountError when amount is 0',
        () async {
      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 0,
        notificationMethod: NotificationMethod.sms,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error, isA<InvalidAmountError>());
      verifyNever(() => fundRepo.getAvailableFunds());
    });

    test('invalid amount — returns InvalidAmountError when amount is negative',
        () async {
      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: -50000,
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error, isA<InvalidAmountError>());
    });

    test('amount below minimum — returns AmountBelowMinimumError', () async {
      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 50000, // minimum is 75000
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error,
          isA<AmountBelowMinimumError>());
    });

    test('insufficient balance — returns InsufficientBalanceError', () async {
      when(() => walletRepo.getWallet())
          .thenAnswer((_) async => const Wallet(availableBalance: 50000));

      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error,
          isA<InsufficientBalanceError>());
    });

    test('duplicate subscription — returns DuplicateSubscriptionError', () async {
      when(() => subscriptionRepo.getActiveSubscriptions()).thenAnswer(
        (_) async => [
          Subscription(
            id: 'existing-id',
            fundId: 1,
            fundName: 'FPV_PACTUAL_RECAUDADORA',
            category: FundCategory.fpv,
            subscribedAmount: 75000,
            subscribedAt: testDate,
            notificationMethod: NotificationMethod.email,
            isActive: true,
          ),
        ],
      );

      final result = await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error,
          isA<DuplicateSubscriptionError>());
    });

    test('fund not found — returns FundNotFoundError', () async {
      final result = await useCase(const SubscribeToFundInput(
        fundId: 999,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
      ));

      expect(result, isA<Failure<Subscription>>());
      expect((result as Failure<Subscription>).error, isA<FundNotFoundError>());
    });

    test('subscription creates a transaction record with correct fields',
        () async {
      await useCase(const SubscribeToFundInput(
        fundId: 1,
        amount: 100000,
        notificationMethod: NotificationMethod.sms,
      ));

      final captured =
          verify(() => transactionRepo.addTransaction(captureAny())).captured;
      final tx = captured.first as Transaction;
      expect(tx.type, TransactionType.subscription);
      expect(tx.amount, 100000);
      expect(tx.fundId, 1);
      expect(tx.notificationMethod, NotificationMethod.sms);
    });
  });
}
