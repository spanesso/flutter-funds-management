import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/transaction_item.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transactionsTitle),
        centerTitle: false,
      ),
      body: switch (state) {
        TransactionsInitial() || TransactionsLoading() => const LoadingWidget(
            message: AppStrings.transactionsLoading,
          ),
        TransactionsError(:final message) => ErrorStateWidget(
            message: message,
            onRetry: () =>
                ref.read(transactionsControllerProvider.notifier).load(),
          ),
        TransactionsEmpty() => const EmptyStateWidget(
            title: AppStrings.transactionsEmptyTitle,
            subtitle: AppStrings.transactionsEmptySubtitle,
            icon: Icons.receipt_long_rounded,
          ),
        TransactionsSuccess(:final transactions) => RefreshIndicator(
            onRefresh: () =>
                ref.read(transactionsControllerProvider.notifier).load(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionItem(transaction: transactions[index]);
              },
            ),
          ),
      },
    );
  }
}
