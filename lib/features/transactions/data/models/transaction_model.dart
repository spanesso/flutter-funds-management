import '../../domain/entities/transaction.dart';

/// DTO for [Transaction]. Represents the raw data contract with the data source.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.amount,
    required this.createdAt,
    this.notificationMethod,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      fundId: json['fund_id'] as int,
      fundName: json['fund_name'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      notificationMethod: json['notification_method'] as String?,
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type.name,
      fundId: entity.fundId,
      fundName: entity.fundName,
      category: entity.category.name,
      amount: entity.amount,
      createdAt: entity.createdAt,
      notificationMethod: entity.notificationMethod?.name,
    );
  }

  final String id;
  final String type;
  final int fundId;
  final String fundName;
  final String category;
  final double amount;
  final DateTime createdAt;
  final String? notificationMethod;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'fund_id': fundId,
        'fund_name': fundName,
        'category': category,
        'amount': amount,
        'created_at': createdAt.toIso8601String(),
        'notification_method': notificationMethod,
      };
}
