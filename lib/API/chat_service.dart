import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Communication/chat_model.dart';
import 'package:healthcareapp_try1/Models/Communication/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// استورد ملف الـ Model اللي عملناه في الخطوة السابقة
// import 'models/chat_model.dart';

class ChatService {
  // تعريف الـ Dio instance
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev/api',
      connectTimeout: const Duration(seconds: 5), // وقت انتظار الاتصال
      receiveTimeout: const Duration(seconds: 3), // وقت انتظار الرد
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List<Chat>> fetchChats() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // 2. قراءة التوكن (استخدم نفس المفتاح 'key' اللي خزنت بيه التوكن)
      final String? token = prefs.getString('token');

      // 3. التحقق من وجود التوكن
      if (token == null) {
        throw Exception("Authentication token not found!");
      }
      // إرسال طلب الـ GET مع التوكن
      final response = await _dio.get(
        '/Chats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Dio بيقوم بعمل jsonDecode تلقائياً، فبنتعامل مع الـ data مباشرة
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Chat.fromJson(json)).toList();
      } else {
        throw Exception("Status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // معالجة أخطاء Dio (مثل ضعف الإنترنت أو خطأ في السيرفر)
      String errorMessage = _handleError(e);
      throw Exception(errorMessage);
    }
  }

  Future<PaginatedMessages> fetchMessages(String chatId, int page) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await _dio.get(
        '/Chats/$chatId/messages', // الـ Path Param
        queryParameters: {
          'page': page,
          'pageSize': 20, // القيمة الافتراضية
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return PaginatedMessages.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Failed to load messages: ${e.message}");
    }
  }

  // دالة مساعدة للتعامل مع أنواع الأخطاء المختلفة
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "فشل الاتصال: انتهت مهلة الاتصال بالخادم.";
      case DioExceptionType.badResponse:
        return "خطأ من السيرفر: ${error.response?.statusCode}";
      case DioExceptionType.connectionError:
        return "تأكد من اتصالك بالإنترنت.";
      default:
        return "حدث خطأ غير متوقع.";
    }
  }
}
