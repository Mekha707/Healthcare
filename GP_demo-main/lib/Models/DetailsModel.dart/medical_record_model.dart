// lib/Models/MedicalRecord/medical_record_model.dart

class MedicalRecordModel {
  final String name;
  final String dateOfBirth;
  final String gender;
  final double weight;
  final MedicalConditions medicalConditions;
  final List<DiagnosisModel> diagnoses;
  final List<LabResultModel> labResults;
  final List<RequiredTest> pendingRequiredTests;

  MedicalRecordModel({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    required this.medicalConditions,
    required this.diagnoses,
    required this.labResults,
    required this.pendingRequiredTests,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) =>
      MedicalRecordModel(
        name: json['name'] ?? '',
        dateOfBirth: json['dateOfBirth'] ?? '',
        gender: json['gender'] ?? '',
        weight: (json['weight'] ?? 0).toDouble(),
        medicalConditions: MedicalConditions.fromJson(
          json['medicalConditions'],
        ),
        diagnoses: (json['diagnoses'] as List? ?? [])
            .map((e) => DiagnosisModel.fromJson(e))
            .toList(),
        labResults: (json['labResults'] as List? ?? [])
            .map((e) => LabResultModel.fromJson(e))
            .toList(),
        pendingRequiredTests: (json['pendingRequiredTests'] as List? ?? [])
            .map((e) => RequiredTest.fromJson(e))
            .toList(),
      );
}

class MedicalConditions {
  final bool hasDiabetes;
  final bool hasBloodPressure;
  final bool hasAsthma;
  final bool hasHeartDisease;
  final bool hasKidneyDisease;
  final bool hasArthritis;
  final bool hasCancer;
  final bool hasHighCholesterol;
  final String? otherMedicalConditions;

  MedicalConditions({
    required this.hasDiabetes,
    required this.hasBloodPressure,
    required this.hasAsthma,
    required this.hasHeartDisease,
    required this.hasKidneyDisease,
    required this.hasArthritis,
    required this.hasCancer,
    required this.hasHighCholesterol,
    this.otherMedicalConditions,
  });

  factory MedicalConditions.fromJson(Map<String, dynamic> json) =>
      MedicalConditions(
        hasDiabetes: json['hasDiabetes'] ?? false,
        hasBloodPressure: json['hasBloodPressure'] ?? false,
        hasAsthma: json['hasAsthma'] ?? false,
        hasHeartDisease: json['hasHeartDisease'] ?? false,
        hasKidneyDisease: json['hasKidneyDisease'] ?? false,
        hasArthritis: json['hasArthritis'] ?? false,
        hasCancer: json['hasCancer'] ?? false,
        hasHighCholesterol: json['hasHighCholesterol'] ?? false,
        otherMedicalConditions: json['otherMedicalConditions'],
      );

  // قائمة الأمراض الموجودة فقط - للعرض
  List<String> get activeConditions {
    final Map<String, bool> all = {
      'Diabetes': hasDiabetes,
      'Blood Pressure': hasBloodPressure,
      'Asthma': hasAsthma,
      'Heart Disease': hasHeartDisease,
      'Kidney Disease': hasKidneyDisease,
      'Arthritis': hasArthritis,
      'Cancer': hasCancer,
      'High Cholesterol': hasHighCholesterol,
    };
    return all.entries.where((e) => e.value).map((e) => e.key).toList();
  }
}

class DiagnosisModel {
  final String appointmentId;
  final String doctorName;
  final String appointmentDate;
  final String appointmentType;
  final String diagnosis;
  final String prescription;
  final List<RequiredTest> requiredTests;

  DiagnosisModel({
    required this.appointmentId,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentType,
    required this.diagnosis,
    required this.prescription,
    required this.requiredTests,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) => DiagnosisModel(
    appointmentId: json['appointmentId'] ?? '',
    doctorName: json['doctorName'] ?? '',
    appointmentDate: json['appointmentDate'] ?? '',
    appointmentType: json['appointmentType'] ?? '',
    diagnosis: json['diagnosis'] ?? '',
    prescription: json['prescription'] ?? '',
    requiredTests: (json['requiredTests'] as List? ?? [])
        .map((e) => RequiredTest.fromJson(e))
        .toList(),
  );
}

class LabResultModel {
  final String appointmentId;
  final String labName;
  final String appointmentDate;
  final String appointmentType;
  final List<TestResult> results;

  LabResultModel({
    required this.appointmentId,
    required this.labName,
    required this.appointmentDate,
    required this.appointmentType,
    required this.results,
  });

  factory LabResultModel.fromJson(Map<String, dynamic> json) => LabResultModel(
    appointmentId: json['appointmentId'] ?? '',
    labName: json['labName'] ?? '',
    appointmentDate: json['appointmentDate'] ?? '',
    appointmentType: json['appointmentType'] ?? '',
    results: (json['results'] as List? ?? [])
        .map((e) => TestResult.fromJson(e))
        .toList(),
  );
}

class TestResult {
  final String testId;
  final String testName;
  final double value;
  final String summary;
  final String resultFileUrl;
  final String status;
  final String submittedAt;

  TestResult({
    required this.testId,
    required this.testName,
    required this.value,
    required this.summary,
    required this.resultFileUrl,
    required this.status,
    required this.submittedAt,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    testId: json['testId'] ?? '',
    testName: json['testName'] ?? '',
    value: (json['value'] ?? 0).toDouble(),
    summary: json['summary'] ?? '',
    resultFileUrl: json['resultFileUrl'] ?? '',
    status: json['status'] ?? '',
    submittedAt: json['submittedAt'] ?? '',
  );
}

class RequiredTest {
  final String testId;
  final String testName;
  final String status;

  RequiredTest({
    required this.testId,
    required this.testName,
    required this.status,
  });

  factory RequiredTest.fromJson(Map<String, dynamic> json) => RequiredTest(
    testId: json['testId'] ?? '',
    testName: json['testName'] ?? '',
    status: json['status'] ?? '',
  );
}
