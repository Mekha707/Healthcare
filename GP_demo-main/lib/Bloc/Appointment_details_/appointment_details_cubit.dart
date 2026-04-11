// lib/Bloc/AppointmentDetails/appointment_details_cubit.dart

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppointmentDetailsState {}

class AppointmentDetailsInitial extends AppointmentDetailsState {}

class AppointmentDetailsLoading extends AppointmentDetailsState {}

class AppointmentDetailsError extends AppointmentDetailsState {
  final String message;
  AppointmentDetailsError(this.message);
}

// ✅ state منفصل لكل نوع
class DoctorAppointmentLoaded extends AppointmentDetailsState {
  final DoctorAppointmentDetails data;
  DoctorAppointmentLoaded(this.data);
}

class NurseAppointmentLoaded extends AppointmentDetailsState {
  final NurseAppointmentDetails data;
  NurseAppointmentLoaded(this.data);
}

class LabAppointmentLoaded extends AppointmentDetailsState {
  final LabAppointmentDetails data;
  LabAppointmentLoaded(this.data);
}

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final UserService _userService;
  AppointmentDetailsCubit(this._userService)
    : super(AppointmentDetailsInitial());

  Future<void> fetchDetails(String id, String type) async {
    emit(AppointmentDetailsLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        emit(AppointmentDetailsError('يجب تسجيل الدخول أولاً'));
        return;
      }

      switch (type) {
        case 'Doctor':
          final data = await _userService.getDoctorAppointmentById(id, token);
          emit(DoctorAppointmentLoaded(data));
          break;
        case 'Nurse':
          final data = await _userService.getNurseAppointmentById(id, token);
          emit(NurseAppointmentLoaded(data));
          break;
        case 'Lab':
          final data = await _userService.getLabAppointmentById(id, token);
          emit(LabAppointmentLoaded(data));
          break;
        default:
          emit(AppointmentDetailsError('نوع الحجز غير معروف'));
      }
    } on AppException catch (e) {
      log("AppException: ${e.message}"); // أضف هذا السطر
      emit(AppointmentDetailsError(e.message));
    } catch (e) {
      log("Unexpected Error: $e"); // أضف هذا السطر
      emit(AppointmentDetailsError('حدث خطأ غير متوقع'));
    }
  }
}
