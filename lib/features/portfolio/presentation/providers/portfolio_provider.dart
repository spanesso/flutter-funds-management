import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../../../core/result/result.dart';

/// Exposes the set of fund IDs with active subscriptions.
/// Used by FundsListPage to show active/available state on each FundCard.
final activeSubscriptionFundIdsProvider =
    FutureProvider<Set<int>>((ref) async {
  final useCase = ref.watch(getActiveSubscriptionsProvider);
  final result = await useCase();
  switch (result) {
    case Success(:final data):
      return data.map((s) => s.fundId).toSet();
    case Failure():
      return <int>{};
  }
});
