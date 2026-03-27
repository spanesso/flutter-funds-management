/// Raw exceptions thrown by the datasource layer.
/// Repository implementations catch these and either rethrow or
/// the use cases catch them and convert to [AppError] via [Result].

class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;
}

class StorageException implements Exception {
  const StorageException([this.message]);
  final String? message;
}

class UnknownException implements Exception {
  const UnknownException([this.message]);
  final String? message;
}

/// Thrown by [TransactionGuard] when a transaction fails security validation.
class TransactionSecurityException implements Exception {
  const TransactionSecurityException(this.message);
  final String message;

  @override
  String toString() => 'TransactionSecurityException: $message';
}
