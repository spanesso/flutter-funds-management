import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> getWallet();
  Future<void> updateBalance(double newBalance);
}
