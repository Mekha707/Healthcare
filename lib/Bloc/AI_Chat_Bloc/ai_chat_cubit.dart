// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/API/chat_service.dart';
// import 'package:healthcareapp_try1/Bloc/ChatBloc/chat_state.dart';
// import 'package:healthcareapp_try1/Models/AI/chat_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class ChatCubit extends Cubit<ChatState> {
//   final ChatService _chatService = ChatService();

//   // قائمة لتخزين تاريخ المحادثة أثناء الجلسة
//   List<dynamic> history = [];

//   ChatCubit() : super(ChatInitial());

//   Future<void> sendSymptoms(String message, {String? imagePath}) async {
//     // 1. ضيف رسالة المستخدم أولاً للقائمة (اختياري لو عايز تعرضها)
//     // history.add(UserMessage(message));

//     emit(
//       ChatLoading(),
//     ); // ممكن تبعت الـ history هنا برضه لو عايز الـ UI يفضل عارض القديم وقت التحميل

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       final response = await _chatService.sendMessage(
//         message: message,
//         token: token,
//         filePath: imagePath,
//       );

//       // 2. ضيف الرد الجديد للقائمة
//       history.add(response);
//       await saveHistory();
//       // 3. ابعت القائمة كاملة للـ UI
//       emit(ChatSuccess(List.from(history)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> saveHistory() async {
//     final prefs = await SharedPreferences.getInstance();

//     List<Map<String, dynamic>> data = history.map((e) {
//       final res = e as ChatResponse;
//       return res.toJson();
//     }).toList();

//     prefs.setString('chat_history', jsonEncode(data));
//   }

//   Future<void> loadHistory() async {
//     final prefs = await SharedPreferences.getInstance();

//     final dataString = prefs.getString('chat_history');
//     if (dataString != null) {
//       final List decoded = jsonDecode(dataString);

//       history = decoded.map((e) => ChatResponse.fromJson(e)).toList();

//       emit(ChatLoaded()); // أو أي state عندك
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/ai_chat_service.dart';
import 'package:healthcareapp_try1/Bloc/AI_Chat_Bloc/ai_chat_state.dart';
import 'package:healthcareapp_try1/Models/AI/chat_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final AiChatService _chatService = AiChatService();
  bool isTyping = false;
  List<ChatMessage> history = [];

  AiChatCubit() : super(AiChatInitial());

  Future<void> sendSymptoms(String message, {String? imagePath}) async {
    // رسالة المستخدم
    history.add(ChatMessage(message: message, isUser: true));

    isTyping = true;
    emit(AiChatSuccess(List.from(history)));

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await _chatService.sendMessage(
        message: message,
        token: token,
        filePath: imagePath,
      );

      isTyping = false;

      history.add(
        ChatMessage(
          message: response.message,
          isUser: false,
          doctors: response.recommendedDoctors,
        ),
      );

      await saveHistory();

      emit(AiChatSuccess(List.from(history)));
    } catch (e) {
      isTyping = false;
      emit(AiChatError(e.toString()));
    }
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final data = history.map((e) => e.toJson()).toList();

    await prefs.setString('chat_history', jsonEncode(data));
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final dataString = prefs.getString('chat_history');

    if (dataString != null && dataString.isNotEmpty) {
      final List decoded = jsonDecode(dataString);

      history = decoded.map((e) => ChatMessage.fromJson(e)).toList();

      emit(AiChatSuccess(List.from(history)));
    }
  }
}
