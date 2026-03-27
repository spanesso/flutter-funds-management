import '../entities/fund.dart';

abstract class FundRepository {
  Future<List<Fund>> getAvailableFunds();
}
