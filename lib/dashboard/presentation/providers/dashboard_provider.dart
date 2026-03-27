import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../features/subscription/domain/entities/subscription.dart';
import '../../../features/subscription/presentation/providers/subscription_provider.dart';
import '../../../features/wallet/domain/entities/wallet.dart';
import '../../../features/wallet/presentation/providers/wallet_provider.dart';

class DashboardData {
  const DashboardData({
    required this.availableBalance,
    required this.activeFundsCount,
    required this.totalInvested,
  });

  final double availableBalance;
  final int activeFundsCount;
  final double totalInvested;
}

sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess(this.data);
  final DashboardData data;
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref) : super(const DashboardInitial()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const DashboardLoading();
    try {
      final walletResult =
          await _ref.read(getWalletBalanceProvider).call();
      final subscriptionsResult =
          await _ref.read(getActiveSubscriptionsProvider).call();

      if (walletResult is Failure) {
        state = DashboardError(
          (walletResult as Failure).error.userMessage,
        );
        return;
      }
      if (subscriptionsResult is Failure) {
        state = DashboardError(
          (subscriptionsResult as Failure).error.userMessage,
        );
        return;
      }

      final wallet = (walletResult as Success<Wallet>).data;
      final subscriptions =
          (subscriptionsResult as Success<List<Subscription>>).data;
      final totalInvested = subscriptions.fold<double>(
        0.0,
        (sum, s) => sum + s.subscribedAmount,
      );

      state = DashboardSuccess(
        DashboardData(
          availableBalance: wallet.availableBalance,
          activeFundsCount: subscriptions.length,
          totalInvested: totalInvested,
        ),
      );
    } catch (_) {
      state = const DashboardError('Ocurrió un error inesperado. Intenta de nuevo.');
    }
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(ref);
});
