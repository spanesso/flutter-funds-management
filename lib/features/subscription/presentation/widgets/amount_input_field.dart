import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';

class AmountInputField extends StatefulWidget {
  const AmountInputField({
    super.key,
    required this.controller,
    required this.minimumAmount,
    required this.availableBalance,
    this.onChanged,
  });

  final TextEditingController controller;
  final double minimumAmount;
  final double availableBalance;
  final ValueChanged<double?>? onChanged;

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  String? _errorText;

  void _validate(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(cleaned);

    setState(() {
      if (cleaned.isEmpty || amount == null) {
        _errorText = null;
      } else if (amount <= 0) {
        _errorText = AppStrings.amountErrorZero;
      } else if (amount < widget.minimumAmount) {
        _errorText = AppStrings.amountErrorMinimum(
            CurrencyFormatter.format(widget.minimumAmount));
      } else if (amount > widget.availableBalance) {
        _errorText = AppStrings.amountErrorBalance(
            CurrencyFormatter.format(widget.availableBalance));
      } else {
        _errorText = null;
      }
    });

    widget.onChanged?.call(
      (_errorText == null && amount != null && amount > 0) ? amount : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.amountLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: AppStrings.amountHint,
            prefixText: AppStrings.amountCurrencyPrefix,
            suffixText: '.00',
            errorText: _errorText,
            helperText: AppStrings.amountHelperMinimum(
                CurrencyFormatter.format(widget.minimumAmount)),
          ),
          onChanged: _validate,
          onFieldSubmitted: _validate,
        ),
      ],
    );
  }
}
