import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/fund.dart';
import '../providers/funds_provider.dart';

sealed class FundsState {
  const FundsState();
}

final class FundsInitial extends FundsState {
  const FundsInitial();
}

final class FundsLoading extends FundsState {
  const FundsLoading();
}

final class FundsSuccess extends FundsState {
  const FundsSuccess(this.funds);
  final List<Fund> funds;
}

final class FundsEmpty extends FundsState {
  const FundsEmpty();
}

final class FundsError extends FundsState {
  const FundsError(this.message);
  final String message;
}

class FundsController extends StateNotifier<FundsState> {
  FundsController(this._ref) : super(const FundsInitial()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const FundsLoading();
    final result = await _ref.read(getAvailableFundsProvider).call();
    switch (result) {
      case Success(:final data):
        state = data.isEmpty ? const FundsEmpty() : FundsSuccess(data);
      case Failure(:final error):
        state = FundsError(error.userMessage);
    }
  }
}

final fundsControllerProvider =
    StateNotifierProvider<FundsController, FundsState>((ref) {
  return FundsController(ref);
});
