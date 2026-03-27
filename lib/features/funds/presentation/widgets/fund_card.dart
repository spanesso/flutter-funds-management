import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/fund.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.isSubscribed,
    required this.onSubscribe,
    required this.onCancel,
    this.isLoading = false,
  });

  final Fund fund;
  final bool isSubscribed;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  /// When true the action button is replaced by a progress indicator,
  /// indicating that a cancel/subscribe operation is in progress for this card.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    fund.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _CategoryChip(category: fund.category),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${AppStrings.fundMinimumPrefix}${CurrencyFormatter.format(fund.minimumAmount)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const Spacer(),
                _StatusBadge(isSubscribed: isSubscribed),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (isLoading)
              const SizedBox(
                height: 44,
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              )
            else if (isSubscribed)
              OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text(AppStrings.fundCancelButton),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: onSubscribe,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text(AppStrings.fundSubscribeButton),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final FundCategory category;

  @override
  Widget build(BuildContext context) {
    final isFpv = category == FundCategory.fpv;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isFpv ? AppColors.chipFpv : AppColors.chipFic,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.displayName,
        style: TextStyle(
          color: isFpv ? AppColors.chipFpvText : AppColors.chipFicText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isSubscribed});
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: isSubscribed
            ? AppColors.secondary.withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSubscribed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 12,
            color: isSubscribed ? AppColors.secondary : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isSubscribed
                ? AppStrings.fundStatusActive
                : AppStrings.fundStatusAvailable,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSubscribed ? AppColors.secondary : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
