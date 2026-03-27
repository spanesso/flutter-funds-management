/// Immutable record of a single transaction attempt in the audit trail.
/// Once created, an [AuditEntry] can never be mutated — append-only semantics.
class AuditEntry {
  const AuditEntry({
    required this.transactionId,
    required this.fundId,
    required this.amount,
    required this.type,
    required this.timestamp,
    required this.outcome,
    this.rejectionReason,
  });

  final String transactionId;
  final int fundId;
  final double amount;
  final String type; // 'subscription' | 'cancellation'
  final DateTime timestamp;
  final AuditOutcome outcome;
  final String? rejectionReason;

  @override
  String toString() =>
      '[AuditEntry] $timestamp | $type | fundId=$fundId | '
      'amount=$amount | outcome=$outcome'
      '${rejectionReason != null ? ' | reason=$rejectionReason' : ''}';
}

enum AuditOutcome { accepted, rejected }
