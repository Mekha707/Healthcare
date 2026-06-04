import 'package:healthcareapp_try1/API/cancellation_service.dart';

class CancellationRepository {
  final CancellationService service;

  CancellationRepository({required this.service});

  Future<void> cancelAppointment({
    required String appointmentId,
    required String appointmentType,
  }) async {
    await service.cancelAppointment(
      appointmentId: appointmentId,
      appointmentType: appointmentType,
    );
  }
}
