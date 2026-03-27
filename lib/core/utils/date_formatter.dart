import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateFormatter {
  DateFormatter._();

  static final _formatter = DateFormat(
    'dd/MM/yyyy HH:mm',
    AppConstants.dateLocale,
  );

  static String format(DateTime date) => _formatter.format(date);
}
