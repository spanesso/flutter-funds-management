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
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/subscription_card.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage> {
  /// Fund ID currently being cancelled, or null if no operation is running.
  int? _cancellingFundId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(portfolioControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.portfolioTitle),
        centerTitle: false,
      ),
      body: switch (state) {
        PortfolioInitial() || PortfolioLoading() => const LoadingWidget(
            message: AppStrings.portfolioLoading,
          ),
        PortfolioError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () =>
                ref.read(portfolioControllerProvider.notifier).load(),
          ),
        PortfolioEmpty() => EmptyStateWidget(
            title: AppStrings.portfolioEmptyTitle,
            subtitle: AppStrings.portfolioEmptySubtitle,
            icon: Icons.account_balance_rounded,
            actionLabel: AppStrings.portfolioEmptyAction,
            action: () => context.go('/funds'),
          ),
        PortfolioSuccess(:final subscriptions) => RefreshIndicator(
            onRefresh: () =>
                ref.read(portfolioControllerProvider.notifier).load(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: subscriptions.length,
              itemBuilder: (_, index) {
                final sub = subscriptions[index];
                return SubscriptionCard(
                  subscription: sub,
                  isLoading: _cancellingFundId == sub.fundId,
                  onCancel: () => _handleCancel(sub.fundId, sub.fundName),
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
        content: Text(AppStrings.cancelDialogBodyPortfolio(fundName)),
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

    final result = await ref
        .read(portfolioControllerProvider.notifier)
        .cancelSubscription(fundId);

    if (!mounted) return;
    setState(() => _cancellingFundId = null);

    switch (result) {
      case Success():
        context.showSuccessSnackBar(AppStrings.cancelSuccessPortfolio);
        ref.read(dashboardControllerProvider.notifier).load();
        ref.read(transactionsControllerProvider.notifier).load();
        ref.invalidate(activeSubscriptionFundIdsProvider);
      case Failure(:final error):
        context.showErrorSnackBar(error.userMessage);
    }
  }
}
