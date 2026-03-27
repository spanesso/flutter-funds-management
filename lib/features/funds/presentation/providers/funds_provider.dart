import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../datasource/mock_datasource.dart';
import '../../data/repositories/fund_repository_impl.dart';
import '../../domain/repositories/fund_repository.dart';
import '../../domain/usecases/get_available_funds.dart';

final fundRepositoryProvider = Provider<FundRepository>((ref) {
  final datasource = ref.watch(mockDatasourceProvider);
  return FundRepositoryImpl(datasource);
});

final getAvailableFundsProvider = Provider<GetAvailableFunds>((ref) {
  return GetAvailableFunds(ref.watch(fundRepositoryProvider));
});
