import 'audit_entry.dart';

/// Append-only in-memory audit log for all transaction attempts.
///
/// In a production banking system this would persist to an immutable
/// write-ahead log (WAL) or a dedicated audit database. Here we keep it
/// in-memory while preserving the same interface so a real implementation
/// can be swapped in without touching the domain.
class TransactionAuditLog {
  TransactionAuditLog._();

  static final TransactionAuditLog instance = TransactionAuditLog._();

  final List<AuditEntry> _entries = [];

  /// Returns an unmodifiable view of all audit entries (oldest first).
  List<AuditEntry> get entries => List.unmodifiable(_entries);

  /// Appends a new [AuditEntry]. Entries cannot be removed or modified.
  void record(AuditEntry entry) {
    _entries.add(entry);
    // In production: persist to WAL / audit DB here.
    // ignore: avoid_print
    print(entry.toString());
  }

  /// Returns all entries for a specific transaction ID.
  List<AuditEntry> entriesFor(String transactionId) =>
      _entries.where((e) => e.transactionId == transactionId).toList();

  /// Clears the log — only for use in tests.
  // ignore: invalid_use_of_visible_for_testing_member
  void clearForTesting() => _entries.clear();
}
