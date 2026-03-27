import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../../subscription/domain/entities/subscription.dart';
import '../../../subscription/domain/usecases/cancel_fund_subscription.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

sealed class PortfolioState {
  const PortfolioState();
}

final class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

final class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

final class PortfolioSuccess extends PortfolioState {
  const PortfolioSuccess(this.subscriptions);
  final List<Subscription> subscriptions;
}

final class PortfolioEmpty extends PortfolioState {
  const PortfolioEmpty();
}

final class PortfolioError extends PortfolioState {
  const PortfolioError(this.message);
  final String message;
}

class PortfolioController extends StateNotifier<PortfolioState> {
  PortfolioController(this._ref) : super(const PortfolioInitial()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const PortfolioLoading();
    final result = await _ref.read(getActiveSubscriptionsProvider).call();
    switch (result) {
      case Success(:final data):
        state = data.isEmpty ? const PortfolioEmpty() : PortfolioSuccess(data);
      case Failure(:final error):
        state = PortfolioError(error.userMessage);
    }
  }

  Future<Result<void>> cancelSubscription(int fundId) async {
    final useCase = _ref.read(cancelFundSubscriptionProvider);
    final result = await useCase(CancelFundSubscriptionInput(fundId: fundId));
    if (result.isSuccess) {
      await load();
    }
    return result;
  }
}

final portfolioControllerProvider =
    StateNotifierProvider<PortfolioController, PortfolioState>((ref) {
  return PortfolioController(ref);
});
