import '../../domain/entities/subscription.dart';

/// DTO for [Subscription]. Represents the raw data contract with the data source.
class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.subscribedAmount,
    required this.subscribedAt,
    required this.notificationMethod,
    required this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      fundId: json['fund_id'] as int,
      fundName: json['fund_name'] as String,
      category: json['category'] as String,
      subscribedAmount: (json['subscribed_amount'] as num).toDouble(),
      subscribedAt: DateTime.parse(json['subscribed_at'] as String),
      notificationMethod: json['notification_method'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  factory SubscriptionModel.fromEntity(Subscription entity) {
    return SubscriptionModel(
      id: entity.id,
      fundId: entity.fundId,
      fundName: entity.fundName,
      category: entity.category.name,
      subscribedAmount: entity.subscribedAmount,
      subscribedAt: entity.subscribedAt,
      notificationMethod: entity.notificationMethod.name,
      isActive: entity.isActive,
    );
  }

  final String id;
  final int fundId;
  final String fundName;
  final String category;
  final double subscribedAmount;
  final DateTime subscribedAt;
  final String notificationMethod;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fund_id': fundId,
        'fund_name': fundName,
        'category': category,
        'subscribed_amount': subscribedAmount,
        'subscribed_at': subscribedAt.toIso8601String(),
        'notification_method': notificationMethod,
        'is_active': isActive,
      };
}
