import '../../domain/entities/wallet.dart';

/// DTO for [Wallet]. Represents the raw data contract with the data source.
class WalletModel {
  const WalletModel({required this.availableBalance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      availableBalance: (json['available_balance'] as num).toDouble(),
    );
  }

  factory WalletModel.fromEntity(Wallet entity) {
    return WalletModel(availableBalance: entity.availableBalance);
  }

  final double availableBalance;

  Map<String, dynamic> toJson() => {'available_balance': availableBalance};
}
