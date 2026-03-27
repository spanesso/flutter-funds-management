import '../../domain/entities/fund.dart';
import '../models/fund_model.dart';

/// Bidirectional mapper between [FundModel] (DTO) and [Fund] (domain entity).
class FundMapper {
  const FundMapper._();

  static Fund toDomain(FundModel model) {
    return Fund(
      id: model.id,
      name: model.name,
      category: _parseCategory(model.category),
      minimumAmount: model.minimumAmount,
    );
  }

  static FundModel toModel(Fund entity) => FundModel.fromEntity(entity);

  static List<Fund> toDomainList(List<FundModel> models) =>
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
}
