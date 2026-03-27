import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/technical_errors.dart';
import '../../../../core/result/result.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class GetActiveSubscriptions {
  const GetActiveSubscriptions(this._repository);
  final SubscriptionRepository _repository;

  Future<Result<List<Subscription>>> call() async {
    try {
      final subscriptions = await _repository.getActiveSubscriptions();
      return Success(subscriptions);
    } on NetworkException {
      return const Failure(NetworkError());
    } catch (_) {
      return const Failure(UnknownError());
    }
  }
}
