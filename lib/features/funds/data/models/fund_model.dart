import '../../domain/entities/fund.dart';

/// DTO for [Fund]. Represents the raw data contract with the data source.
/// In production this would be JSON-serializable via json_serializable.
class FundModel {
  const FundModel({
    required this.id,
    required this.name,
    required this.category,
    required this.minimumAmount,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      minimumAmount: (json['minimum_amount'] as num).toDouble(),
    );
  }

  final int id;
  final String name;
  final String category;
  final double minimumAmount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'minimum_amount': minimumAmount,
      };

  static String _categoryToString(FundCategory category) {
    switch (category) {
      case FundCategory.fpv:
        return 'fpv';
      case FundCategory.fic:
        return 'fic';
    }
  }

  factory FundModel.fromEntity(Fund entity) {
    return FundModel(
      id: entity.id,
      name: entity.name,
      category: _categoryToString(entity.category),
      minimumAmount: entity.minimumAmount,
    );
  }
}
