import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';

class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({
    super.key,
    required this.activeFundsCount,
    required this.totalInvested,
  });

  final int activeFundsCount;
  final double totalInvested;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                icon: Icons.account_balance_rounded,
                label: AppStrings.dashboardActiveFundsLabel,
                value: activeFundsCount.toString(),
                iconColor: AppColors.primary,
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: AppColors.cardBorder,
            ),
            Expanded(
              child: _SummaryItem(
                icon: Icons.trending_up_rounded,
                label: AppStrings.dashboardTotalInvestedLabel,
                value: CurrencyFormatter.format(totalInvested),
                iconColor: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: iconColor,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
