import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancellationService {
  final Dio _dio;

  CancellationService(this._dio);

  Future<void> cancelAppointment({
    required String appointmentId,
    required String appointmentType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await _dio.patch(
      '/api/Appointments/$appointmentId/cancellation',
      data: {'appointmentType': appointmentType},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('فشل إلغاء الموعد: ${response.statusCode}');
    }
  }
}
