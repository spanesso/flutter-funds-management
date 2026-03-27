import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../datasource/mock_datasource.dart';
import '../../data/repositories/secure_transaction_repository.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/security/transaction_audit_log.dart';
import '../../domain/security/transaction_guard.dart';
import '../../domain/usecases/get_transactions_history.dart';

final _transactionGuardProvider = Provider<TransactionGuard>((ref) {
  return TransactionGuard(TransactionAuditLog.instance);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final datasource = ref.watch(mockDatasourceProvider);
  final impl = TransactionRepositoryImpl(datasource);
  final guard = ref.watch(_transactionGuardProvider);
  return SecureTransactionRepository(delegate: impl, guard: guard);
});

final getTransactionsHistoryProvider = Provider<GetTransactionsHistory>((ref) {
  return GetTransactionsHistory(ref.watch(transactionRepositoryProvider));
});
