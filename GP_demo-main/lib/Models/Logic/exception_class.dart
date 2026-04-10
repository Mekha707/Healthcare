class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException() : super("لا يوجد اتصال بالإنترنت أو انتهت مهلة الطلب.");
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException()
    : super("جلسة العمل انتهت، يرجى تسجيل الدخول مرة أخرى.", 401);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, 400);
}
