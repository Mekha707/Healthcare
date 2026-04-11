import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/login_response_model.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/register_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/medical_record_model.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ... باقي الـ imports

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://unalterably-unasphalted-felton.ngrok-free.dev",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ),
  );

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        // ✅ هندلة الـ 401 تلقائياً في كل الـ requests
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // ممكن تعمل logout تلقائي هنا لو حبيت
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {"email": email, "password": password},
      );
      final user = LoginResponse.fromJson(response.data);
      await _saveUserData(user);
      return user;
    } on DioException catch (e) {
      // ✅ هنا بنعالج الـ 400 و 401 للـ login تحديداً
      final status = e.response?.statusCode;
      if (status == 400 || status == 401) {
        throw const AppException("البريد الإلكتروني أو كلمة المرور غير صحيحة");
      }
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> register(RegisterModel userModel) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: userModel.toJson(),
      );
      return response.data?['userId']?.toString() ?? '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/api/auth/forgot-password', data: {'email': email});
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> confirmEmail(String email, String otp) async {
    try {
      await _dio.post(
        '/api/auth/confirm-email',
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _dio.post(
        '/api/auth/verify-reset-otp',
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/api/auth/reset-password',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _dio.post(
        '/api/auth/resend-confirmation-email',
        data: {'email': email},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw const UnauthorizedException();
    }

    try {
      await _dio.post(
        '/api/auth/change-password',
        data: {
          'userId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<PatientProfile> getPatientProfile() async {
    try {
      final response = await _dio.get("/api/patients/profile");
      return PatientProfile.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updatePatientProfile({
    required String userId,
    required String name,
    required String phoneNumber,
    required String address,
    String? addressUrl,
    required String city,
    double? weight,
  }) async {
    try {
      final formData = FormData.fromMap({
        "UserId": userId,
        "Name": name,
        "PhoneNumber": phoneNumber,
        "Address": address,
        "City": city,
        if (addressUrl != null && addressUrl.isNotEmpty)
          "AddressUrl": addressUrl,
        if (weight != null) "Weight": weight.toString(),
      });

      await _dio.put(
        "/api/patients/profile",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<String>> getCities() async {
    try {
      final response = await _dio.get('/api/Locations/cities');
      return (response.data as List).map((e) => e.toString()).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ✅ Helper خاص لحفظ بيانات المستخدم
  Future<void> _saveUserData(LoginResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token);
    await prefs.setString('userId', user.id);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userName', user.name);
    await prefs.setString('userRole', user.role);
  }

  Future<MedicalRecordModel> getMedicalRecord() async {
    try {
      final response = await _dio.get('/api/Patients/me/medical-record');
      return MedicalRecordModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
