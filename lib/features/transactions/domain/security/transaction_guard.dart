import '../../../../core/errors/exceptions.dart';
import '../entities/transaction.dart';
import 'audit_entry.dart';
import 'transaction_audit_log.dart';

/// Domain service that enforces pre-write security invariants before a
/// [Transaction] is persisted.
///
/// Rules enforced (banking security layer):
///   1. Amount must be strictly positive.
///   2. Transaction ID must not already exist in the audit log (idempotency /
///      replay-attack prevention).
///
/// Throws [TransactionSecurityException] if any rule is violated.
/// On success, writes an [AuditEntry] with [AuditOutcome.accepted].
class TransactionGuard {
  const TransactionGuard(this._auditLog);

  final TransactionAuditLog _auditLog;

  /// Validates [transaction] and records the outcome in the audit log.
  ///
  /// Throws [TransactionSecurityException] if validation fails.
  void validate(Transaction transaction) {
    // Rule 1: amount must be positive
    if (transaction.amount <= 0) {
      _reject(
        transaction,
        reason: 'Amount must be positive (got ${transaction.amount})',
      );
      throw TransactionSecurityException(
        'Invalid amount: ${transaction.amount}',
      );
    }

    // Rule 2: idempotency — reject duplicate transaction IDs
    final alreadySeen = _auditLog.entries
        .any((e) => e.transactionId == transaction.id && e.outcome == AuditOutcome.accepted);
    if (alreadySeen) {
      _reject(
        transaction,
        reason: 'Duplicate transaction ID detected: ${transaction.id}',
      );
      throw TransactionSecurityException(
        'Duplicate transaction: ${transaction.id}',
      );
    }

    // All rules passed — record accepted entry
    _auditLog.record(
      AuditEntry(
        transactionId: transaction.id,
        fundId: transaction.fundId,
        amount: transaction.amount,
        type: transaction.type.name,
        timestamp: DateTime.now(),
        outcome: AuditOutcome.accepted,
      ),
    );
  }

  void _reject(Transaction transaction, {required String reason}) {
    _auditLog.record(
      AuditEntry(
        transactionId: transaction.id,
        fundId: transaction.fundId,
        amount: transaction.amount,
        type: transaction.type.name,
        timestamp: DateTime.now(),
        outcome: AuditOutcome.rejected,
        rejectionReason: reason,
      ),
    );
  }
}
