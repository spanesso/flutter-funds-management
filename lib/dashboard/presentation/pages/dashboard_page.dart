import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/quick_actions_row.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        centerTitle: false,
      ),
      body: switch (state) {
        DashboardInitial() || DashboardLoading() => const LoadingWidget(
            message: AppStrings.dashboardLoading,
          ),
        DashboardError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () =>
                ref.read(dashboardControllerProvider.notifier).load(),
          ),
        DashboardSuccess(:final data) => RefreshIndicator(
            onRefresh: () =>
                ref.read(dashboardControllerProvider.notifier).load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                BalanceCard(balance: data.availableBalance),
                const SizedBox(height: AppSpacing.md),
                PortfolioSummaryCard(
                  activeFundsCount: data.activeFundsCount,
                  totalInvested: data.totalInvested,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Acciones rápidas', // section header, not in AppStrings intentionally
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                QuickActionsRow(
                  onViewFunds: () => context.go('/funds'),
                  onViewHistory: () => context.go('/transactions'),
                ),
              ],
            ),
          ),
      },
    );
  }
}
