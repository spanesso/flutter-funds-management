import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../funds/domain/entities/fund.dart';

part 'subscription.freezed.dart';

enum NotificationMethod {
  email,
  sms;

  String get displayName {
    switch (this) {
      case NotificationMethod.email:
        return AppStrings.notificationEmail;
      case NotificationMethod.sms:
        return AppStrings.notificationSms;
    }
  }
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required int fundId,
    required String fundName,
    required FundCategory category,
    required double subscribedAmount,
    required DateTime subscribedAt,
    required NotificationMethod notificationMethod,
    required bool isActive,
  }) = _Subscription;
}
