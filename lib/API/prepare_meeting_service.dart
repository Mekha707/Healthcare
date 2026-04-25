// lib/features/appointments/data/repositories/appointment_repository.dart

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Communication/prepare_meeting.dart';

class AppointmentRepository {
  final Dio _dio;

  AppointmentRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl:
                  'https://unalterably-unasphalted-felton.ngrok-free.dev', // ← غير ده
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<PrepareMeetingModel> prepareMeeting({
    required String appointmentId,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '/api/doctor-appointments/$appointmentId/prepare-meetings',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return PrepareMeetingModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong: ${e.message}');
    }
  }
}
