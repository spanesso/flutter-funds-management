import '../result/result.dart';
export '../result/result.dart' show AppError;

abstract class BusinessError extends AppError {
  const BusinessError();
}

abstract class TechnicalError extends AppError {
  const TechnicalError();
}
