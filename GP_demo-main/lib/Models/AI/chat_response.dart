// // class ChatResponse {
// //   final String message;
// //   final String suggestedSpecialty;
// //   final List<Doctor> recommendedDoctors;

// //   ChatResponse({
// //     required this.message,
// //     required this.suggestedSpecialty,
// //     required this.recommendedDoctors,
// //   });

// //   factory ChatResponse.fromJson(Map<String, dynamic> json) {
// //     return ChatResponse(
// //       message: json['message'],
// //       suggestedSpecialty: json['suggestedSpecialty'],
// //       recommendedDoctors: (json['recommendedDoctors'] as List)
// //           .map((i) => Doctor.fromJson(i))
// //           .toList(),
// //     );
// //   }
// // }

// // class Doctor {
// //   final String name;
// //   final String specialty;
// //   final double rating;

// //   Doctor({required this.name, required this.specialty, required this.rating});

// //   factory Doctor.fromJson(Map<String, dynamic> json) {
// //     return Doctor(
// //       name: json['name'] ?? 'Unknown Doctor',
// //       specialty: json['specialty'] ?? 'General',
// //       rating: (json['rating'] ?? 0.0).toDouble(),
// //     );
// //   }
// // }

// // داخل ملف chat_response.dart

// import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

// class ChatResponse {
//   final String message;
//   final List<Doctor> recommendedDoctors;

//   ChatResponse({required this.message, required this.recommendedDoctors});

//   factory ChatResponse.fromJson(Map<String, dynamic> json) {
//     return ChatResponse(
//       // 1. استخدم الـ ?? (Null-coalescing operator) عشان تدي قيمة افتراضية لو الـ message جاية null
//       message: json['message']?.toString() ?? "No response message from AI",

//       // 2. تأكد من الـ list إنها مش null برضه
//       recommendedDoctors: (json['recommendedDoctors'] as List? ?? [])
//           .map((i) => Doctor.fromJson(i))
//           .toList(),
//     );
//   }
// }

import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

class ChatResponse {
  final String message;
  final List<Doctor> recommendedDoctors;

  ChatResponse({required this.message, required this.recommendedDoctors});

  // ✅ fromJson
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] ?? '',
      recommendedDoctors: (json['recommendedDoctors'] as List? ?? [])
          .map((e) => Doctor.fromJson(e))
          .toList(),
    );
  }

  // ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'recommendedDoctors': recommendedDoctors.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final List<Doctor>? doctors;

  ChatMessage({required this.message, required this.isUser, this.doctors});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((e) => Doctor.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isUser': isUser,
      'doctors': doctors?.map((e) => e.toJson()).toList(),
    };
  }
}
