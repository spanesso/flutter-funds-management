import '../constants/app_strings.dart';
import 'app_error.dart';

class NetworkError extends TechnicalError {
  const NetworkError();
  @override
  String get userMessage => AppStrings.errNetwork;
}

class ParsingError extends TechnicalError {
  const ParsingError();
  @override
  String get userMessage => AppStrings.errParsing;
}

class StorageError extends TechnicalError {
  const StorageError();
  @override
  String get userMessage => AppStrings.errStorage;
}

class UnknownError extends TechnicalError {
  const UnknownError();
  @override
  String get userMessage => AppStrings.errUnknown;
}
