import '../../../funds/domain/entities/fund.dart';
import '../../../subscription/domain/entities/subscription.dart';
import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

/// Bidirectional mapper between [TransactionModel] (DTO) and [Transaction] (domain entity).
class TransactionMapper {
  const TransactionMapper._();

  static Transaction toDomain(TransactionModel model) {
    return Transaction(
      id: model.id,
      type: _parseType(model.type),
      fundId: model.fundId,
      fundName: model.fundName,
      category: _parseCategory(model.category),
      amount: model.amount,
      createdAt: model.createdAt,
      notificationMethod: model.notificationMethod != null
          ? _parseNotification(model.notificationMethod!)
          : null,
    );
  }

  static TransactionModel toModel(Transaction entity) =>
      TransactionModel.fromEntity(entity);

  static List<Transaction> toDomainList(List<TransactionModel> models) =>
      models.map(toDomain).toList();

  static TransactionType _parseType(String raw) {
    switch (raw.toLowerCase()) {
      case 'subscription':
        return TransactionType.subscription;
      case 'cancellation':
        return TransactionType.cancellation;
      default:
        throw ArgumentError('Unknown TransactionType: $raw');
    }
  }

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
