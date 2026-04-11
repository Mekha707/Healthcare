import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException()
    : super("انتهت الجلسة، يرجى تسجيل الدخول مجدداً", statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException() : super("ليس لديك صلاحية للوصول", statusCode: 403);
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class ErrorHandler {
  static AppException handle(Object error) {
    if (error is AppException) return error; // مررناه كما هو
    if (error is DioException) return _handleDio(error);
    return const AppException("حدث خطأ غير متوقع");
  }

  static AppException _handleDio(DioException e) {
    // أخطاء الاتصال
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException("انتهت مهلة الاتصال، تحقق من الإنترنت");
      case DioExceptionType.connectionError:
        return const NetworkException("لا يوجد اتصال بالإنترنت");
      default:
        break;
    }

    // أخطاء السيرفر
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(_extractMessage(data, "Invalid request"));
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const ServerException(
          "Server is not available",
          statusCode: 404,
        );
      case 422:
        return ValidationException(
          _extractMessage(data, "Data validation failed"),
        );
      case 500:
        return const ServerException(
          "Server error, please try again later",
          statusCode: 500,
        );
      default:
        return ServerException(
          _extractMessage(data, "حدث خطأ ما (${statusCode ?? 'unknown'})"),
          statusCode: statusCode,
        );
    }
  }

  static String _extractMessage(dynamic data, String fallback) {
    if (data is! Map) return fallback;
    if (data['message'] != null) return data['message'].toString();
    if (data['title'] != null) return data['title'].toString();
    if (data['errors'] != null) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    }
    return fallback;
  }
}
