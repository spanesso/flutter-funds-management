import '../../../../datasource/mock_datasource.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._datasource);
  final MockDatasource _datasource;

  @override
  Future<Wallet> getWallet() => _datasource.getWallet();

  @override
  Future<void> updateBalance(double newBalance) =>
      _datasource.updateWalletBalance(newBalance);
}
