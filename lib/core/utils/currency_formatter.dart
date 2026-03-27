import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: AppConstants.currencyLocale,
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);

  static double? parse(String value) {
    final cleaned = value
        .replaceAll(AppConstants.currencySymbol, '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned);
  }
}
