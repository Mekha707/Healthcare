// lib/Models/Booking_Models/appointment_details_model.dart

class ReviewDetails {
  final String id;
  final String patientName;
  final int rating;
  final String comment;
  final DateTime date;
  final bool isUpdated;

  ReviewDetails({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isUpdated,
  });

  factory ReviewDetails.fromJson(Map<String, dynamic> json) => ReviewDetails(
    id: json['id'] ?? '',
    patientName: json['patientName'] ?? '',
    rating: json['rating'] ?? 0,
    comment: json['comment'] ?? '',
    date: DateTime.parse(json['date']),
    isUpdated: json['isUpdated'] ?? false,
  );
}

// ─── Doctor Appointment Details ───
class DoctorAppointmentDetails {
  final String id;
  final String doctorId;
  final String patientId;
  final String doctorName;
  final String appointmentType;
  final String status;
  final String date;
  final String startTime;
  final String endTime;
  final double fee;
  final String? notes;
  final String? address;
  final String paymentType;
  final String? diagnosis;
  final String? prescriptions;
  final List<RequiredTestDetail> requiredTests;
  final ReviewDetails? review;

  DoctorAppointmentDetails({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.appointmentType,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.fee,
    this.notes,
    this.address,
    required this.paymentType,
    this.diagnosis,
    this.prescriptions,
    required this.requiredTests,
    this.review,
  });

  factory DoctorAppointmentDetails.fromJson(Map<String, dynamic> json) =>
      DoctorAppointmentDetails(
        id: json['id'] ?? '',
        doctorId: json['doctorId'] ?? '',
        patientId: json['patientId'] ?? '',
        doctorName: json['doctorName'] ?? '',
        appointmentType: json['appointmentType'] ?? '',
        status: json['status'] ?? '',
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        fee: (json['fee'] ?? 0).toDouble(),
        notes: json['notes'],
        address: json['address'],
        paymentType: json['paymentType'] ?? '',
        diagnosis: json['diagnosis'],
        prescriptions: json['prescriptions'],
        requiredTests: (json['requiredTests'] as List? ?? [])
            .map((e) => RequiredTestDetail.fromJson(e))
            .toList(),
        review: json['review'] != null
            ? ReviewDetails.fromJson(json['review'])
            : null,
      );
}

// ─── Nurse Appointment Details ───
class NurseAppointmentDetails {
  final String id;
  final String nurseId;
  final String patientId;
  final String nurseName;
  final String serviceType;
  final String status;
  final String date;
  final String shiftStartTime;
  final String shiftEndTime;
  final String appointmentStartTime;
  final double totalFee;
  final String? notes;
  final String? address;
  final int? hours;
  final ReviewDetails? review;

  NurseAppointmentDetails({
    required this.id,
    required this.nurseId,
    required this.patientId,
    required this.nurseName,
    required this.serviceType,
    required this.status,
    required this.date,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.appointmentStartTime,
    required this.totalFee,
    this.notes,
    this.address,
    this.hours,
    this.review,
  });

  factory NurseAppointmentDetails.fromJson(Map<String, dynamic> json) =>
      NurseAppointmentDetails(
        id: json['id'] ?? '',
        nurseId: json['nurseId'] ?? '',
        patientId: json['patientId'] ?? '',
        nurseName: json['nurseName'] ?? '',
        serviceType: json['serviceType'] ?? '',
        status: json['status'] ?? '',
        date: json['date'] ?? '',
        shiftStartTime: json['shiftStartTime'] ?? '',
        shiftEndTime: json['shiftEndTime'] ?? '',
        appointmentStartTime: json['appointmentStartTime'] ?? '',
        totalFee: (json['totalFee'] ?? 0).toDouble(),
        notes: json['notes'],
        address: json['address'],
        hours: json['hours'],
        review: json['review'] != null
            ? ReviewDetails.fromJson(json['review'])
            : null,
      );
}

// ─── Lab Appointment Details ───
class LabAppointmentDetails {
  final String id;
  final String labId;
  final String patientId;
  final String labName;
  final String appointmentType;
  final String status;
  final String date;
  final String startTime;
  final double totalFee;
  final String? notes;
  final String? address;
  final List<LabTestResult> testResults;
  final ReviewDetails? review;

  LabAppointmentDetails({
    required this.id,
    required this.labId,
    required this.patientId,
    required this.labName,
    required this.appointmentType,
    required this.status,
    required this.date,
    required this.startTime,
    required this.totalFee,
    this.notes,
    this.address,
    required this.testResults,
    this.review,
  });

  factory LabAppointmentDetails.fromJson(Map<String, dynamic> json) =>
      LabAppointmentDetails(
        id: json['id'] ?? '',
        labId: json['labId'] ?? '',
        patientId: json['patientId'] ?? '',
        labName: json['labName'] ?? '',
        appointmentType: json['appointmentType'] ?? '',
        status: json['status'] ?? '',
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        totalFee: (json['totalFee'] ?? 0).toDouble(),
        notes: json['notes'],
        address: json['address'],
        testResults: (json['testResults'] as List? ?? [])
            .map((e) => LabTestResult.fromJson(e))
            .toList(),
        review: json['review'] != null
            ? ReviewDetails.fromJson(json['review'])
            : null,
      );
}

// ─── Shared Models ───
class RequiredTestDetail {
  final String testId;
  final String testName;
  final String status;

  RequiredTestDetail({
    required this.testId,
    required this.testName,
    required this.status,
  });

  factory RequiredTestDetail.fromJson(Map<String, dynamic> json) =>
      RequiredTestDetail(
        testId: json['testId'] ?? '',
        testName: json['testName'] ?? '',
        status: json['status'] ?? '',
      );
}

class LabTestResult {
  final String testId;
  final String testName;
  final double value;
  final String summary;
  final String resultFileUrl;
  final String status;
  final String submittedAt;

  LabTestResult({
    required this.testId,
    required this.testName,
    required this.value,
    required this.summary,
    required this.resultFileUrl,
    required this.status,
    required this.submittedAt,
  });

  factory LabTestResult.fromJson(Map<String, dynamic> json) => LabTestResult(
    testId: json['testId'] ?? '',
    testName: json['testName'] ?? '',
    value: (json['value'] ?? 0).toDouble(),
    summary: json['summary'] ?? '',
    resultFileUrl: json['resultFileUrl'] ?? '',
    status: json['status'] ?? '',
    submittedAt: json['submittedAt'] ?? '',
  );
}
