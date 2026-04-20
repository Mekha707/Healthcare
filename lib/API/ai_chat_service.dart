import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/AI/chat_response.dart';

class AiChatService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://unalterably-unasphalted-felton.ngrok-free.dev/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<ChatResponse> sendMessage({
    required String message,
    String? token,
    String? filePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "Message": message,
        if (filePath != null)
          "Attachment": await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        "api/Patients/ai-chat",
        data: formData,
        options: Options(
          headers: {if (token != null) "Authorization": "Bearer $token"},
          contentType: "multipart/form-data",
        ),
      );

      return ChatResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Chat Error: $e");
    }
  }
}
