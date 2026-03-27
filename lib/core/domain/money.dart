/// Value Object that encapsulates monetary logic and enforces non-negativity.
/// All monetary operations in the domain must go through this type.
class Money {
  const Money._(this._amount);

  factory Money(double amount) {
    if (amount < 0) {
      throw ArgumentError.value(
        amount,
        'amount',
        'Money amount cannot be negative.',
      );
    }
    return Money._(amount);
  }

  factory Money.fromDouble(double amount) => Money(amount);

  static const Money zero = Money._(0);

  final double _amount;

  double get amount => _amount;

  bool get isZero => _amount == 0;
  bool get isPositive => _amount > 0;

  Money operator +(Money other) => Money._(_amount + other._amount);

  /// Subtracts [other] from this. Throws [InsufficientFundsException] if the
  /// result would be negative, enforcing the invariant at the value-object level.
  Money operator -(Money other) {
    final result = _amount - other._amount;
    if (result < 0) {
      throw InsufficientFundsException(
        'Cannot subtract ${other._amount} from ${_amount}: result would be negative.',
      );
    }
    return Money._(result);
  }

  bool operator >=(Money other) => _amount >= other._amount;
  bool operator <=(Money other) => _amount <= other._amount;
  bool operator >(Money other) => _amount > other._amount;
  bool operator <(Money other) => _amount < other._amount;

  @override
  bool operator ==(Object other) =>
      other is Money && other._amount == _amount;

  @override
  int get hashCode => _amount.hashCode;

  @override
  String toString() => 'Money(${_amount.toStringAsFixed(2)} COP)';
}

class InsufficientFundsException implements Exception {
  const InsufficientFundsException(this.message);
  final String message;

  @override
  String toString() => 'InsufficientFundsException: $message';
}
