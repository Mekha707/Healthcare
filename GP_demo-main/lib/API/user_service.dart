import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/API/details_service.dart';
import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/doctor_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/lab_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/nurse_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';
import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  late final Dio _dio;

  UserService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // ─────────────────────── Doctor ───────────────────────

  Future<PaginatedList<Doctor>> getDoctors({
    int page = 1,
    String? name,
    String? specialtyId,
    String? location,
    String? serviceType,
  }) async {
    try {
      final params = <String, dynamic>{'Page': page, 'PageSize': 10};
      if (name?.isNotEmpty == true) params['Search'] = name;
      if (specialtyId?.isNotEmpty == true) params['SpecialityId'] = specialtyId;
      if (location?.isNotEmpty == true) params['City'] = location;
      if (serviceType != null) params['AppointmentType'] = serviceType;

      final response = await _dio.get('api/Doctors', queryParameters: params);
      return PaginatedList.fromJson(response.data, Doctor.fromJson);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<DoctorDetailsModel> getDoctorById(String doctorId) async {
    try {
      final response = await _dio.get('api/doctors/$doctorId');
      final apiResponse = DetailsService.fromJson(
        response.data as Map<String, dynamic>,
        DoctorDetailsModel.fromJson,
      );
      return _handleResponse(apiResponse);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>?> bookDoctorAppointment({
    required String doctorId,
    required String doctorSlotId,
    required String appointmentType,
    required String token,
    String? notes,
    String? address,
  }) async {
    try {
      final data = <String, dynamic>{
        "doctorId": doctorId,
        "doctorSlotId": doctorSlotId,
        "appointmentType": appointmentType,
        if (notes != null) "notes": notes,
        if (appointmentType == "HomeVisit" && address != null)
          "address": address,
      };

      final response = await _dio.post(
        'api/doctor-appointments',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ─────────────────────── Nurse ───────────────────────

  Future<PaginatedList<Nurse>> getNurses({
    int page = 1,
    String? name,
    String? city,
  }) async {
    try {
      final params = <String, dynamic>{'Page': page, 'PageSize': 10};
      if (name?.isNotEmpty == true) params['Search'] = name;
      if (city?.isNotEmpty == true) params['City'] = city;

      final response = await _dio.get('api/Nurses', queryParameters: params);
      return PaginatedList.fromJson(response.data, Nurse.fromJson);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<NurseDetailsModel> getNurseById(String nurseId) async {
    try {
      final response = await _dio.get('api/nurses/$nurseId');
      final apiResponse = DetailsService.fromJson(
        response.data as Map<String, dynamic>,
        NurseDetailsModel.fromJson,
      );
      return _handleResponse(apiResponse);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> bookNurseAppointment({
    required String nurseId,
    required String shiftId,
    required String serviceType,
    required String token,
    required String address,
    String? notes,
    int? hours,
    String? startTime,
  }) async {
    try {
      final data = <String, dynamic>{
        "nurseId": nurseId,
        "shiftId": shiftId,
        "serviceType": serviceType,
        "address": address.trim(),
        "hours": hours ?? 1,
        if (notes?.isNotEmpty == true) "notes": notes,
        if (startTime != null) "startTime": startTime,
      };

      log("Nurse Booking Request: $data");
      await _dio.post(
        'api/nurse-appointments',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ─────────────────────── Lab ───────────────────────

  Future<List<LabModel>> getLabs({
    int page = 1,
    String? name,
    String? location,
    List<String>? testIds,
  }) async {
    try {
      final params = <String, dynamic>{'Page': page, 'PageSize': 10};
      if (name?.isNotEmpty == true) params['Search'] = name;
      if (location?.isNotEmpty == true) params['City'] = location;
      if (testIds?.isNotEmpty == true) params['TestIds'] = testIds;

      final response = await _dio.get('api/Labs', queryParameters: params);
      final data = response.data;

      if (data is List) {
        return data.map((j) => LabModel.fromJson(j)).toList();
      }
      if (data is Map) {
        final list = data['items'] ?? data['data'] ?? [];
        return (list as List).map((j) => LabModel.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<LabDetailsModel> getLabById(String id) async {
    try {
      final response = await _dio.get('api/Labs/$id');
      return LabDetailsModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> bookLabAppointment({
    required String labId,
    required String date,
    required String appointmentType,
    required List<String> labTestsIds,
    required String token,
    String? startTime,
    String? notes,
    String? address,
  }) async {
    try {
      if (appointmentType == "HomeVisit" && (address?.trim().isEmpty ?? true)) {
        throw const ValidationException("العنوان مطلوب للزيارة المنزلية");
      }

      final data = <String, dynamic>{
        'labId': labId,
        'date': date,
        'appointmentType': appointmentType,
        'labTestsIds': labTestsIds,
        if (startTime != null) 'startTime': startTime,
        if (notes?.isNotEmpty == true) 'notes': notes,
        if (appointmentType == "HomeVisit") 'address': address!.trim(),
      };

      await _dio.post(
        'api/lab-appointments',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ─────────────────────── Reviews ───────────────────────

  Future<PaginatedList<ReviewModel>> getReviews(
    String targetId,
    String targetType, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'api/Reviews',
        queryParameters: {
          'TargetId': targetId,
          'TargetType': targetType,
          'pageNumber': page,
          'pageSize': 10,
        },
      );
      return PaginatedList.fromJson(response.data, ReviewModel.fromJson);
    } catch (e) {
      log("Reviews Error [$targetType]: $e");
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> submitReview({
    required String targetId,
    required String targetType, // "Doctor" / "Nurse" / "Lab"
    required int rating,
    String? comment,
    required String token,
  }) async {
    try {
      await _dio.post(
        'api/Reviews',
        data: {
          'targetId': targetId,
          'targetType': targetType,
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ─────────────────────── Specialties & Tests ───────────────────────

  Future<List<Specialty>> getAllSpecialties() async {
    try {
      final response = await _dio.get('api/Specialties');
      return (response.data as List).map((j) => Specialty.fromJson(j)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<Test>> fetchTests() async {
    try {
      final response = await _dio.get('api/Tests');
      return (response.data as List).map((j) => Test.fromJson(j)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ─────────────────────── Helpers ───────────────────────

  T _handleResponse<T>(DetailsService<T> response) {
    if (response.isSuccess && response.value != null) return response.value!;
    final msg = response.error?.description ?? 'حدث خطأ أثناء تحميل التفاصيل';
    throw AppException(msg);
  }

  Future<DoctorAppointmentDetails> getDoctorAppointmentById(
    String id,
    String token,
  ) async {
    try {
      final response = await _dio.get(
        'api/doctor-appointments/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // أضف هذا السطر
      );
      return DoctorAppointmentDetails.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<NurseAppointmentDetails> getNurseAppointmentById(
    String id,
    String token,
  ) async {
    try {
      final response = await _dio.get(
        'api/nurse-appointments/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // أضف هذا السطر
      );
      return NurseAppointmentDetails.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<LabAppointmentDetails> getLabAppointmentById(
    String id,
    String token,
  ) async {
    try {
      final response = await _dio.get(
        'api/lab-appointments/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // أضف هذا السطر
      );
      return LabAppointmentDetails.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
