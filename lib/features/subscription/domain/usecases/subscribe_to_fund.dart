import 'package:uuid/uuid.dart';

import '../../../../core/errors/business_errors.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../../../funds/domain/repositories/fund_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class SubscribeToFundInput {
  const SubscribeToFundInput({
    required this.fundId,
    required this.amount,
    required this.notificationMethod,
  });

  final int fundId;
  final double amount;
  final NotificationMethod notificationMethod;
}

class SubscribeToFund {
  const SubscribeToFund({
    required FundRepository fundRepository,
    required WalletRepository walletRepository,
    required SubscriptionRepository subscriptionRepository,
    required TransactionRepository transactionRepository,
  })  : _fundRepository = fundRepository,
        _walletRepository = walletRepository,
        _subscriptionRepository = subscriptionRepository,
        _transactionRepository = transactionRepository;

  final FundRepository _fundRepository;
  final WalletRepository _walletRepository;
  final SubscriptionRepository _subscriptionRepository;
  final TransactionRepository _transactionRepository;

  Future<Result<Subscription>> call(SubscribeToFundInput input) async {
    try {
      // RN-02 / validation 1: amount must be > 0
      if (input.amount <= 0) {
        return const Failure(InvalidAmountError());
      }

      // validation 2: fund must exist
      final funds = await _fundRepository.getAvailableFunds();
      final fundIndex = funds.indexWhere((f) => f.id == input.fundId);
      if (fundIndex == -1) {
        return const Failure(FundNotFoundError());
      }
      final fund = funds[fundIndex];

      // RN-02 / validation 3: amount >= fund minimum
      if (input.amount < fund.minimumAmount) {
        return Failure(AmountBelowMinimumError(minimumAmount: fund.minimumAmount));
      }

      // RN-03 / validation 4: wallet balance >= amount
      final wallet = await _walletRepository.getWallet();
      if (wallet.availableBalance < input.amount) {
        return const Failure(InsufficientBalanceError());
      }

      // RN-11 / validation 5: no active duplicate — POLICY: REJECT
      final activeSubscriptions =
          await _subscriptionRepository.getActiveSubscriptions();
      final hasDuplicate =
          activeSubscriptions.any((s) => s.fundId == input.fundId);
      if (hasDuplicate) {
        return const Failure(DuplicateSubscriptionError());
      }

      // Create subscription
      const uuid = Uuid();
      final now = DateTime.now();
      final subscription = Subscription(
        id: uuid.v4(),
        fundId: fund.id,
        fundName: fund.name,
        category: fund.category,
        subscribedAmount: input.amount,
        subscribedAt: now,
        notificationMethod: input.notificationMethod,
        isActive: true,
      );

      await _subscriptionRepository.createSubscription(subscription);

      // RN-07: deduct from wallet immediately
      final newBalance = wallet.availableBalance - input.amount;
      await _walletRepository.updateBalance(newBalance);

      // RN-05: create subscription transaction
      final transaction = Transaction(
        id: uuid.v4(),
        type: TransactionType.subscription,
        fundId: fund.id,
        fundName: fund.name,
        category: fund.category,
        amount: input.amount,
        createdAt: now,
        notificationMethod: input.notificationMethod,
      );
      await _transactionRepository.addTransaction(transaction);

      return Success(subscription);
    } on TransactionSecurityException catch (e) {
      return Failure(TransactionRejectedError(e.message));
    } on NetworkException {
      return const Failure(NetworkError());
    } on StorageException {
      return const Failure(StorageError());
    } catch (_) {
      return const Failure(UnknownError());
    }
  }
}
