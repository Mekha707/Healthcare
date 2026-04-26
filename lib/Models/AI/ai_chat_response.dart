// lib/Models/AI/chat_response.dart

import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

class AiChatResponse {
  final String message;
  final String suggestedSpecialty;
  final List<Doctor> recommendedDoctors;

  AiChatResponse({
    required this.message,
    required this.suggestedSpecialty,
    required this.recommendedDoctors,
  });

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      message: json['message'] ?? '',
      suggestedSpecialty: json['suggestedSpecialty'] ?? '',
      recommendedDoctors: (json['recommendedDoctors'] as List? ?? [])
          .map((d) => Doctor.fromJson(d))
          .toList(),
    );
  }
}

// lib/Models/AI/chat_message.dart

// class AiChatMessage {
//   final String message;
//   final bool isUser;
//   final List<Doctor> doctors;

//   AiChatMessage({
//     required this.message,
//     required this.isUser,
//     this.doctors = const [],
//   });

//   Map<String, dynamic> toJson() => {
//     'message': message,
//     'isUser': isUser,
//     'doctors': doctors.map((d) => d.toJson()).toList(),
//   };

//   factory AiChatMessage.fromJson(Map<String, dynamic> json) {
//     return AiChatMessage(
//       message: json['message'] ?? '',
//       isUser: json['isUser'] ?? false,
//       doctors: (json['doctors'] as List? ?? [])
//           .map((d) => Doctor.fromJson(d))
//           .toList(),
//     );
//   }
// }

class AiChatMessage {
  final String message;
  final bool isUser;
  final List<Doctor> doctors;
  final String suggestedSpecialty; // ← أضف ده

  AiChatMessage({
    required this.message,
    required this.isUser,
    this.doctors = const [],
    this.suggestedSpecialty = '', // ← أضف ده
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'isUser': isUser,
    'doctors': doctors.map((d) => d.toJson()).toList(),
    'suggestedSpecialty': suggestedSpecialty, // ← أضف ده
  };

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      suggestedSpecialty: json['suggestedSpecialty'] ?? '', // ← أضف ده
      doctors: (json['doctors'] as List? ?? [])
          .map((d) => Doctor.fromJson(d))
          .toList(),
    );
  }
}
