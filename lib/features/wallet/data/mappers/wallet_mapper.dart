import '../../domain/entities/wallet.dart';
import '../models/wallet_model.dart';

/// Bidirectional mapper between [WalletModel] (DTO) and [Wallet] (domain entity).
class WalletMapper {
  const WalletMapper._();

  static Wallet toDomain(WalletModel model) {
    return Wallet(availableBalance: model.availableBalance);
  }

  static WalletModel toModel(Wallet entity) => WalletModel.fromEntity(entity);
}
