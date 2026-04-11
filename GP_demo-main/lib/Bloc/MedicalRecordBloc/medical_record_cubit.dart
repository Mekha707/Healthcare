// lib/Bloc/MedicalRecord/medical_record_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/medical_record_model.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';

abstract class MedicalRecordState {}

class MedicalRecordInitial extends MedicalRecordState {}

class MedicalRecordLoading extends MedicalRecordState {}

class MedicalRecordLoaded extends MedicalRecordState {
  final MedicalRecordModel data;
  MedicalRecordLoaded(this.data);
}

class MedicalRecordError extends MedicalRecordState {
  final String message;
  MedicalRecordError(this.message);
}

class MedicalRecordCubit extends Cubit<MedicalRecordState> {
  final AuthService _authService;
  MedicalRecordCubit(this._authService) : super(MedicalRecordInitial());

  Future<void> fetchMedicalRecord() async {
    emit(MedicalRecordLoading());
    try {
      final data = await _authService.getMedicalRecord();
      emit(MedicalRecordLoaded(data));
    } on AppException catch (e) {
      emit(MedicalRecordError(e.message));
    } catch (_) {
      emit(MedicalRecordError("حدث خطأ غير متوقع"));
    }
  }
}
