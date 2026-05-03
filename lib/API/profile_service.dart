// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/update_profile_model.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';
import 'package:dio/io.dart';

class ProfileService {
  final Dio dio = Dio();
  final String baseUrl = "https://healthcare52.runasp.net";

  Future<void> updateProfile(UpdateProfileModel model) async {
    await dio.put("https://healthcare52.runasp.net", data: model.toJson());
  }

  Future<List<AppointmentModel>> getPatientHistory(String token) async {
    try {
      final response = await dio.get(
        "https://healthcare52.runasp.net/api/Appointments/me/patient-history",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        List<AppointmentModel> allAppointments = [];

        if (jsonData is Map<String, dynamic>) {
          // 1. استخراج مواعيد الدكاترة
          if (jsonData['doctorAppointments'] != null) {
            allAppointments.addAll(
              (jsonData['doctorAppointments'] as List)
                  .map((e) => AppointmentModel.fromJson(e))
                  .toList(),
            );
          }

          // 2. استخراج مواعيد التمريض
          if (jsonData['nurseAppointments'] != null) {
            allAppointments.addAll(
              (jsonData['nurseAppointments'] as List)
                  .map((e) => AppointmentModel.fromJson(e))
                  .toList(),
            );
          }

          // 3. استخراج مواعيد المعامل
          if (jsonData['labAppointments'] != null) {
            allAppointments.addAll(
              (jsonData['labAppointments'] as List)
                  .map((e) => AppointmentModel.fromJson(e))
                  .toList(),
            );
          }
        }

        print("Total Combined Appointments: ${allAppointments.length}");
        return allAppointments;
      } else {
        throw Exception("Error fetching history");
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}
