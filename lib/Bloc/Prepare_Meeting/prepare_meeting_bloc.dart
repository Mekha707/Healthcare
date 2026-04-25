// lib/features/appointments/presentation/bloc/prepare_meeting_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/prepare_meeting_service.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_events.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_state.dart';

class PrepareMeetingBloc
    extends Bloc<PrepareMeetingEvent, PrepareMeetingState> {
  final AppointmentRepository _repository;

  PrepareMeetingBloc({required AppointmentRepository repository})
    : _repository = repository,
      super(PrepareMeetingInitial()) {
    on<PrepareMeetingRequested>(_onPrepareMeetingRequested);
  }

  Future<void> _onPrepareMeetingRequested(
    PrepareMeetingRequested event,
    Emitter<PrepareMeetingState> emit,
  ) async {
    emit(PrepareMeetingLoading());
    try {
      final result = await _repository.prepareMeeting(
        appointmentId: event.appointmentId,
        token: event.token,
      );
      emit(PrepareMeetingSuccess(result));
    } catch (e) {
      emit(PrepareMeetingFailure(e.toString()));
    }
  }
}
