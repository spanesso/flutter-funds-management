import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsHistory {
  const GetTransactionsHistory(this._repository);
  final TransactionRepository _repository;

  Future<Result<List<Transaction>>> call() async {
    try {
      final transactions = await _repository.getTransactions();
      final sorted = List<Transaction>.from(transactions)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(sorted);
    } on NetworkException {
      return const Failure(NetworkError());
    } catch (_) {
      return const Failure(UnknownError());
    }
  }
}
