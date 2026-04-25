// lib/API/ai_chat_service.dart

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/AI/ai_chat_response.dart';

class AiChatService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://unalterably-unasphalted-felton.ngrok-free.dev/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // lib/API/ai_chat_service.dart

  Future<AiChatResponse> sendMessage({
    required String message,
    String? token,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> body = {"message": message};

      print("=== AI REQUEST ===");
      print("URL: api/Patients/ai-chatbot-model");

      print("Token: $token");
      print("Body: $body");

      final response = await _dio.post(
        "api/Patients/ai-olama-model-medgemma",
        data: body,
        options: Options(
          headers: {
            if (token != null) "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      print("=== AI RESPONSE ===");
      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");

      return AiChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("=== DIO ERROR ===");
      print("Type: ${e.type}");
      print("Status: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");
      print("Message: ${e.message}");
      throw Exception("Chat Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("=== UNKNOWN ERROR ===");
      print(e);
      throw Exception("Chat Error: $e");
    }
  }
}
