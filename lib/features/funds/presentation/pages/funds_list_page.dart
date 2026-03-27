import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/result/result.dart';
import '../../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../portfolio/presentation/controllers/portfolio_controller.dart';
import '../../../portfolio/presentation/providers/portfolio_provider.dart';
import '../../../subscription/domain/usecases/cancel_fund_subscription.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../controllers/funds_controller.dart';
import '../widgets/fund_card.dart';

class FundsListPage extends ConsumerStatefulWidget {
  const FundsListPage({super.key});

  @override
  ConsumerState<FundsListPage> createState() => _FundsListPageState();
}

class _FundsListPageState extends ConsumerState<FundsListPage> {
  /// Fund ID currently being cancelled, or null if no operation is running.
  int? _cancellingFundId;

  @override
  Widget build(BuildContext context) {
    final fundsState = ref.watch(fundsControllerProvider);
    final activeFundIds =
        ref.watch(activeSubscriptionFundIdsProvider).valueOrNull ?? <int>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.fundsTitle),
        centerTitle: false,
      ),
      body: switch (fundsState) {
        FundsInitial() || FundsLoading() => const LoadingWidget(
            message: AppStrings.fundsLoading,
          ),
        FundsError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () => ref.read(fundsControllerProvider.notifier).load(),
          ),
        FundsEmpty() => const EmptyStateWidget(
            title: AppStrings.fundsEmptyTitle,
            subtitle: AppStrings.fundsEmptySubtitle,
            icon: Icons.account_balance_rounded,
          ),
        FundsSuccess(:final funds) => RefreshIndicator(
            onRefresh: () async {
              ref.read(fundsControllerProvider.notifier).load();
              ref.invalidate(activeSubscriptionFundIdsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: funds.length,
              itemBuilder: (_, index) {
                final fund = funds[index];
                final isSubscribed = activeFundIds.contains(fund.id);
                return FundCard(
                  fund: fund,
                  isSubscribed: isSubscribed,
                  isLoading: _cancellingFundId == fund.id,
                  onSubscribe: () => context.push('/funds/${fund.id}'),
                  onCancel: () => _handleCancel(fund.id, fund.name),
                );
              },
            ),
          ),
      },
    );
  }

  Future<void> _handleCancel(int fundId, String fundName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.cancelDialogTitle),
        content: Text(AppStrings.cancelDialogBodyFunds(fundName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancelDialogNegative),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.cancelDialogPositive),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _cancellingFundId = fundId);

    final useCase = ref.read(cancelFundSubscriptionProvider);
    final result = await useCase(CancelFundSubscriptionInput(fundId: fundId));

    if (!mounted) return;
    setState(() => _cancellingFundId = null);

    switch (result) {
      case Success():
        context.showSuccessSnackBar(AppStrings.cancelSuccessFunds);
        ref.read(fundsControllerProvider.notifier).load();
        ref.read(dashboardControllerProvider.notifier).load();
        ref.read(portfolioControllerProvider.notifier).load();
        ref.read(transactionsControllerProvider.notifier).load();
        ref.invalidate(activeSubscriptionFundIdsProvider);
      case Failure(:final error):
        context.showErrorSnackBar(error.userMessage);
    }
  }
}
