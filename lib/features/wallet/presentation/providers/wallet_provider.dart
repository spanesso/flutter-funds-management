import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../datasource/mock_datasource.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/get_wallet_balance.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final datasource = ref.watch(mockDatasourceProvider);
  return WalletRepositoryImpl(datasource);
});

final getWalletBalanceProvider = Provider<GetWalletBalance>((ref) {
  return GetWalletBalance(ref.watch(walletRepositoryProvider));
});
