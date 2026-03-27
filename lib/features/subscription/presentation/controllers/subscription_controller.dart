import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/subscribe_to_fund.dart';
import '../providers/subscription_provider.dart';

sealed class SubmitState {
  const SubmitState();
}

final class SubmitIdle extends SubmitState {
  const SubmitIdle();
}

final class SubmitSubmitting extends SubmitState {
  const SubmitSubmitting();
}

final class SubmitSuccess extends SubmitState {
  const SubmitSuccess(this.subscription);
  final Subscription subscription;
}

final class SubmitError extends SubmitState {
  const SubmitError(this.message);
  final String message;
}

class SubscriptionController extends StateNotifier<SubmitState> {
  SubscriptionController(this._ref) : super(const SubmitIdle());

  final Ref _ref;

  Future<void> subscribe({
    required int fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  }) async {
    state = const SubmitSubmitting();
    final useCase = _ref.read(subscribeToFundProvider);
    final result = await useCase(
      SubscribeToFundInput(
        fundId: fundId,
        amount: amount,
        notificationMethod: notificationMethod,
      ),
    );
    switch (result) {
      case Success(:final data):
        state = SubmitSuccess(data);
      case Failure(:final error):
        state = SubmitError(error.userMessage);
    }
  }

  void reset() => state = const SubmitIdle();
}

final subscriptionControllerProvider = StateNotifierProvider.family<
    SubscriptionController, SubmitState, int>((ref, fundId) {
  return SubscriptionController(ref);
});
