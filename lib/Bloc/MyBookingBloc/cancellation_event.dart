part of 'cancellation_bloc.dart';

abstract class CancellationEvent extends Equatable {
  const CancellationEvent();
  @override
  List<Object?> get props => [];
}

class CancelAppointmentRequested extends CancellationEvent {
  final String appointmentId;
  final String appointmentType;

  const CancelAppointmentRequested({
    required this.appointmentId,
    required this.appointmentType,
  });

  @override
  List<Object?> get props => [appointmentId, appointmentType];
}
