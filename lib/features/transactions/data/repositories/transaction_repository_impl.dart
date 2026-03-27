import '../../../../datasource/mock_datasource.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._datasource);
  final MockDatasource _datasource;

  @override
  Future<List<Transaction>> getTransactions() =>
      _datasource.getTransactions();

  @override
  Future<void> addTransaction(Transaction transaction) =>
      _datasource.addTransaction(transaction);
}
