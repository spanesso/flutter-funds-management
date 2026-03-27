import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/subscription.dart';

class NotificationSelector extends StatelessWidget {
  const NotificationSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NotificationMethod? selected;
  final ValueChanged<NotificationMethod?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.notificationLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.notificationDescription,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: NotificationMethod.values.map((method) {
            final isSelected = selected == method;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: InkWell(
                  onTap: () => onChanged(method),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          method == NotificationMethod.email
                              ? Icons.email_outlined
                              : Icons.sms_outlined,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          method.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selected == null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.notificationRequiredError,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
