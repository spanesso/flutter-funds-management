import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/security/transaction_audit_log.dart';
import '../../domain/security/transaction_guard.dart';

/// Decorator that wraps [TransactionRepository] with a banking security layer.
///
/// Before every [addTransaction] call it runs [TransactionGuard.validate],
/// which enforces:
///   - Positive amount invariant
///   - Idempotency (no duplicate transaction IDs)
///
/// Every attempt (accepted or rejected) is recorded in [TransactionAuditLog].
///
/// Uses the **Decorator pattern** so the security concern is completely
/// decoupled from both the domain logic and the data source.
class SecureTransactionRepository implements TransactionRepository {
  SecureTransactionRepository({
    required TransactionRepository delegate,
    required TransactionGuard guard,
  })  : _delegate = delegate,
        _guard = guard;

  final TransactionRepository _delegate;
  final TransactionGuard _guard;

  @override
  Future<List<Transaction>> getTransactions() => _delegate.getTransactions();

  @override
  Future<void> addTransaction(Transaction transaction) {
    // May throw [TransactionSecurityException] — callers (use cases) catch it.
    _guard.validate(transaction);
    return _delegate.addTransaction(transaction);
  }
}
