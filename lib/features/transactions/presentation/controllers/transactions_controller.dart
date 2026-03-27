import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transactions_provider.dart';

sealed class TransactionsState {
  const TransactionsState();
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsSuccess extends TransactionsState {
  const TransactionsSuccess(this.transactions);
  final List<Transaction> transactions;
}

final class TransactionsEmpty extends TransactionsState {
  const TransactionsEmpty();
}

final class TransactionsError extends TransactionsState {
  const TransactionsError(this.message);
  final String message;
}

class TransactionsController extends StateNotifier<TransactionsState> {
  TransactionsController(this._ref) : super(const TransactionsInitial()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const TransactionsLoading();
    final result = await _ref.read(getTransactionsHistoryProvider).call();
    switch (result) {
      case Success(:final data):
        state = data.isEmpty
            ? const TransactionsEmpty()
            : TransactionsSuccess(data);
      case Failure(:final error):
        state = TransactionsError(error.userMessage);
    }
  }
}

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsState>((ref) {
  return TransactionsController(ref);
});
