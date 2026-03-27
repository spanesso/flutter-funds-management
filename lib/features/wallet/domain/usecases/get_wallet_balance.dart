import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalance {
  const GetWalletBalance(this._repository);
  final WalletRepository _repository;

  Future<Result<Wallet>> call() async {
    try {
      final wallet = await _repository.getWallet();
      return Success(wallet);
    } on NetworkException {
      return const Failure<Wallet>(NetworkError());
    } catch (_) {
      return const Failure<Wallet>(UnknownError());
    }
  }
}
