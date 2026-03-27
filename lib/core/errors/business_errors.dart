import '../constants/app_strings.dart';
import 'app_error.dart';

class InsufficientBalanceError extends BusinessError {
  const InsufficientBalanceError();
  @override
  String get userMessage => AppStrings.errInsufficientBalance;
}

class AmountBelowMinimumError extends BusinessError {
  const AmountBelowMinimumError({required this.minimumAmount});
  final double minimumAmount;
  @override
  String get userMessage => AppStrings.errAmountBelowMinimum;
}

class InvalidAmountError extends BusinessError {
  const InvalidAmountError();
  @override
  String get userMessage => AppStrings.errInvalidAmount;
}

class NotificationMethodRequiredError extends BusinessError {
  const NotificationMethodRequiredError();
  @override
  String get userMessage => AppStrings.errNotificationRequired;
}

class FundNotFoundError extends BusinessError {
  const FundNotFoundError();
  @override
  String get userMessage => AppStrings.errFundNotFound;
}

class SubscriptionNotFoundError extends BusinessError {
  const SubscriptionNotFoundError();
  @override
  String get userMessage => AppStrings.errSubscriptionNotFound;
}

class DuplicateSubscriptionError extends BusinessError {
  const DuplicateSubscriptionError();
  @override
  String get userMessage => AppStrings.errDuplicateSubscription;
}

class TransactionRejectedError extends BusinessError {
  const TransactionRejectedError([this.detail]);
  final String? detail;
  @override
  String get userMessage => AppStrings.errTransactionRejected;
}
