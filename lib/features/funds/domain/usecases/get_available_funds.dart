import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../entities/fund.dart';
import '../repositories/fund_repository.dart';

class GetAvailableFunds {
  const GetAvailableFunds(this._repository);
  final FundRepository _repository;

  Future<Result<List<Fund>>> call() async {
    try {
      final funds = await _repository.getAvailableFunds();
      return Success(funds);
    } on NetworkException {
      return const Failure(NetworkError());
    } catch (_) {
      return const Failure(UnknownError());
    }
  }
}
