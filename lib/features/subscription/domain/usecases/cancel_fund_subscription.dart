import 'package:uuid/uuid.dart';

import '../../../../core/errors/business_errors.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../repositories/subscription_repository.dart';

class CancelFundSubscriptionInput {
  const CancelFundSubscriptionInput({required this.fundId});
  final int fundId;
}

class CancelFundSubscription {
  const CancelFundSubscription({
    required SubscriptionRepository subscriptionRepository,
    required WalletRepository walletRepository,
    required TransactionRepository transactionRepository,
  })  : _subscriptionRepository = subscriptionRepository,
        _walletRepository = walletRepository,
        _transactionRepository = transactionRepository;

  final SubscriptionRepository _subscriptionRepository;
  final WalletRepository _walletRepository;
  final TransactionRepository _transactionRepository;

  Future<Result<void>> call(CancelFundSubscriptionInput input) async {
    try {
      // RN-09: must have an active subscription
      final activeSubscriptions =
          await _subscriptionRepository.getActiveSubscriptions();
      final subscriptionMatches =
          activeSubscriptions.where((s) => s.fundId == input.fundId);
      final subscription =
          subscriptionMatches.isEmpty ? null : subscriptionMatches.first;

      if (subscription == null) {
        return const Failure(SubscriptionNotFoundError());
      }

      // Mark subscription as cancelled
      await _subscriptionRepository.cancelSubscription(input.fundId);

      // RN-08: reintegrate amount to wallet immediately
      final wallet = await _walletRepository.getWallet();
      final newBalance = wallet.availableBalance + subscription.subscribedAmount;
      await _walletRepository.updateBalance(newBalance);

      // RN-06: create cancellation transaction
      const uuid = Uuid();
      final transaction = Transaction(
        id: uuid.v4(),
        type: TransactionType.cancellation,
        fundId: subscription.fundId,
        fundName: subscription.fundName,
        category: subscription.category,
        amount: subscription.subscribedAmount,
        createdAt: DateTime.now(),
        notificationMethod: null,
      );
      await _transactionRepository.addTransaction(transaction);

      return const Success(null);
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
