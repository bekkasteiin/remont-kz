class CustomException implements Exception {
  final String cause;
  final Object? error;
  const CustomException(this.cause, [this.error]);

  @override
  String toString() {
    return '$runtimeType $cause';
  }
}

class EntityException extends CustomException {
  const EntityException(cause, [error]) : super(cause, error);
}

class ModelException extends CustomException {
  const ModelException(cause, [error]) : super(cause, error);
}

class NoInternetException extends CustomException {
  const NoInternetException() : super('No internet connection');
}
