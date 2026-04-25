// lib/features/appointments/presentation/bloc/prepare_meeting_state.dart

import 'package:healthcareapp_try1/Models/Communication/prepare_meeting.dart';

abstract class PrepareMeetingState {}

class PrepareMeetingInitial extends PrepareMeetingState {}

class PrepareMeetingLoading extends PrepareMeetingState {}

class PrepareMeetingSuccess extends PrepareMeetingState {
  final PrepareMeetingModel data;
  PrepareMeetingSuccess(this.data);
}

class PrepareMeetingFailure extends PrepareMeetingState {
  final String error;
  PrepareMeetingFailure(this.error);
}
