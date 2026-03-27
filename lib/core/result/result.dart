sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get dataOrThrow {
    final self = this;
    if (self is Success<T>) return self.data;
    throw StateError('Result is Failure: ${(self as Failure<T>).error}');
  }

  AppError get errorOrThrow {
    final self = this;
    if (self is Failure<T>) return self.error;
    throw StateError('Result is Success');
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    return failure((self as Failure<T>).error);
  }
}

abstract class AppError {
  const AppError();
  String get userMessage;
}
