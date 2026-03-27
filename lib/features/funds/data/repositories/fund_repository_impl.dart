import '../../../../datasource/mock_datasource.dart';
import '../../domain/entities/fund.dart';
import '../../domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  const FundRepositoryImpl(this._datasource);
  final MockDatasource _datasource;

  @override
  Future<List<Fund>> getAvailableFunds() => _datasource.getFunds();
}
