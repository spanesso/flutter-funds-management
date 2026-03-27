import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../funds/domain/entities/fund.dart';
import '../../../funds/presentation/controllers/funds_controller.dart';
import '../../../funds/presentation/providers/funds_provider.dart';
import '../../../portfolio/presentation/controllers/portfolio_controller.dart';
import '../../../portfolio/presentation/providers/portfolio_provider.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../domain/entities/subscription.dart';
import '../controllers/subscription_controller.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/notification_selector.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key, required this.fundId});
  final int fundId;

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  final _amountController = TextEditingController();
  double? _validAmount;
  NotificationMethod? _selectedNotification;
  bool _showNotificationError = false;

  Fund? _fund;
  double _availableBalance = 0;
  bool _loadingData = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loadingData = true;
      _loadError = null;
    });

    final fundsResult = await ref.read(getAvailableFundsProvider).call();
    final walletResult = await ref.read(getWalletBalanceProvider).call();

    if (!mounted) return;

    if (fundsResult is Failure) {
      setState(() {
        _loadError = (fundsResult as Failure).error.userMessage;
        _loadingData = false;
      });
      return;
    }
    if (walletResult is Failure) {
      setState(() {
        _loadError = (walletResult as Failure).error.userMessage;
        _loadingData = false;
      });
      return;
    }

    final funds = (fundsResult as Success).data;
    final wallet = (walletResult as Success).data;
    final fundMatches = funds.where((f) => f.id == widget.fundId);
    final fund = fundMatches.isEmpty ? null : fundMatches.first;

    setState(() {
      _fund = fund;
      _availableBalance = wallet.availableBalance;
      _loadingData = false;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _validAmount != null && _selectedNotification != null;

  Future<void> _submit() async {
    setState(() => _showNotificationError = true);
    if (!_canSubmit) return;

    await ref
        .read(subscriptionControllerProvider(widget.fundId).notifier)
        .subscribe(
          fundId: widget.fundId,
          amount: _validAmount!,
          notificationMethod: _selectedNotification!,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) {
      return const Scaffold(
        body: LoadingWidget(message: AppStrings.subscriptionLoading),
      );
    }

    if (_loadError != null || _fund == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.subscriptionPageTitleFallback)),
        body: ErrorStateWidget(
          message: _loadError ?? AppStrings.subscriptionFundNotFound,
          onRetry: _loadData,
        ),
      );
    }

    final submitState = ref.watch(subscriptionControllerProvider(widget.fundId));

    ref.listen(subscriptionControllerProvider(widget.fundId), (prev, next) {
      switch (next) {
        case SubmitSuccess():
          context.showSuccessSnackBar(
            AppStrings.subscriptionSuccess(_fund!.name),
          );
          // Refresh every provider that depends on wallet / subscription state
          ref.read(dashboardControllerProvider.notifier).load();
          ref.read(portfolioControllerProvider.notifier).load();
          ref.read(transactionsControllerProvider.notifier).load();
          ref.read(fundsControllerProvider.notifier).load();
          ref.invalidate(activeSubscriptionFundIdsProvider);
          context.pop();
        case SubmitError(:final message):
          context.showErrorSnackBar(message);
          ref
              .read(subscriptionControllerProvider(widget.fundId).notifier)
              .reset();
        default:
          break;
      }
    });

    final isSubmitting = submitState is SubmitSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.subscriptionPageTitle),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FundHeader(fund: _fund!),
            const SizedBox(height: AppSpacing.lg),
            _BalanceIndicator(balance: _availableBalance),
            const SizedBox(height: AppSpacing.lg),
            AmountInputField(
              controller: _amountController,
              minimumAmount: _fund!.minimumAmount,
              availableBalance: _availableBalance,
              onChanged: (amount) => setState(() => _validAmount = amount),
            ),
            const SizedBox(height: AppSpacing.lg),
            NotificationSelector(
              selected: _selectedNotification,
              onChanged: (method) =>
                  setState(() => _selectedNotification = method),
            ),
            if (_showNotificationError && _selectedNotification == null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  AppStrings.subscriptionNotificationRequiredError,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isSubmitting || !_canSubmit) ? null : _submit,
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(AppStrings.subscriptionConfirmButton),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _FundHeader extends StatelessWidget {
  const _FundHeader({required this.fund});
  final Fund fund;

  @override
  Widget build(BuildContext context) {
    final isFpv = fund.category == FundCategory.fpv;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isFpv
            ? AppColors.chipFpv
            : AppColors.chipFic,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFpv ? AppColors.chipFpvText.withOpacity(0.2) : AppColors.chipFicText.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: isFpv ? AppColors.chipFpvText : AppColors.chipFicText,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  fund.category.displayName,
                  style: TextStyle(
                    color: isFpv ? AppColors.chipFpvText : AppColors.chipFicText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceIndicator extends StatelessWidget {
  const _BalanceIndicator({required this.balance});
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.secondary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppStrings.subscriptionBalancePrefix,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[700]),
          ),
          Text(
            CurrencyFormatter.format(balance),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
