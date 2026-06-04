import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthcareapp_try1/API/cancellation_repository.dart';

part 'cancellation_event.dart';
part 'cancellation_state.dart';

class CancellationBloc extends Bloc<CancellationEvent, CancellationState> {
  final CancellationRepository repository;

  CancellationBloc({required this.repository}) : super(CancellationInitial()) {
    on<CancelAppointmentRequested>(_onCancelRequested);
  }

  Future<void> _onCancelRequested(
    CancelAppointmentRequested event,
    Emitter<CancellationState> emit,
  ) async {
    emit(CancellationLoading());
    try {
      await repository.cancelAppointment(
        appointmentId: event.appointmentId,
        appointmentType: event.appointmentType,
      );
      emit(const CancellationSuccess());
    } catch (e) {
      emit(CancellationFailure(error: e.toString()));
    }
  }
}
