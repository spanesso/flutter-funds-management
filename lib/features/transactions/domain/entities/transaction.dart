import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../funds/domain/entities/fund.dart';
import '../../../subscription/domain/entities/subscription.dart';

part 'transaction.freezed.dart';

enum TransactionType {
  subscription,
  cancellation;

  String get displayName {
    switch (this) {
      case TransactionType.subscription:
        return AppStrings.transactionTypeSubscription;
      case TransactionType.cancellation:
        return AppStrings.transactionTypeCancellation;
    }
  }
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,
    required int fundId,
    required String fundName,
    required FundCategory category,
    required double amount,
    required DateTime createdAt,
    NotificationMethod? notificationMethod,
  }) = _Transaction;
}
