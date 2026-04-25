// lib/features/appointments/presentation/bloc/prepare_meeting_event.dart

abstract class PrepareMeetingEvent {}

class PrepareMeetingRequested extends PrepareMeetingEvent {
  final String appointmentId;
  final String token;

  PrepareMeetingRequested({required this.appointmentId, required this.token});
}
