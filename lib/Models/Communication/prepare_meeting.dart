// lib/features/appointments/data/models/prepare_meeting_model.dart

class PrepareMeetingModel {
  final String meetingUrl;

  PrepareMeetingModel({required this.meetingUrl});

  factory PrepareMeetingModel.fromJson(Map<String, dynamic> json) {
    return PrepareMeetingModel(meetingUrl: json['meetingUrl'] as String);
  }

  Map<String, dynamic> toJson() => {'meetingUrl': meetingUrl};
}
