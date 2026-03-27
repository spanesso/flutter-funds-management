import '../../../funds/domain/entities/fund.dart';
import '../../domain/entities/subscription.dart';
import '../models/subscription_model.dart';

/// Bidirectional mapper between [SubscriptionModel] (DTO) and [Subscription] (domain entity).
class SubscriptionMapper {
  const SubscriptionMapper._();

  static Subscription toDomain(SubscriptionModel model) {
    return Subscription(
      id: model.id,
      fundId: model.fundId,
      fundName: model.fundName,
      category: _parseCategory(model.category),
      subscribedAmount: model.subscribedAmount,
      subscribedAt: model.subscribedAt,
      notificationMethod: _parseNotification(model.notificationMethod),
      isActive: model.isActive,
    );
  }

  static SubscriptionModel toModel(Subscription entity) =>
      SubscriptionModel.fromEntity(entity);

  static List<Subscription> toDomainList(List<SubscriptionModel> models) =>
      models.map(toDomain).toList();

  static FundCategory _parseCategory(String raw) {
    switch (raw.toLowerCase()) {
      case 'fpv':
        return FundCategory.fpv;
      case 'fic':
        return FundCategory.fic;
      default:
        throw ArgumentError('Unknown FundCategory: $raw');
    }
  }

  static NotificationMethod _parseNotification(String raw) {
    switch (raw.toLowerCase()) {
      case 'email':
        return NotificationMethod.email;
      case 'sms':
        return NotificationMethod.sms;
      default:
        throw ArgumentError('Unknown NotificationMethod: $raw');
    }
  }
}
