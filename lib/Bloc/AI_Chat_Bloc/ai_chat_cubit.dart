// lib/Bloc/AI_Chat_Bloc/ai_chat_cubit.dart

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/ai_chat_service.dart';
import 'package:healthcareapp_try1/Bloc/AI_Chat_Bloc/ai_chat_state.dart';
import 'package:healthcareapp_try1/Models/AI/ai_chat_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final AiChatService _chatService = AiChatService();
  bool isTyping = false;
  List<AiChatMessage> history = []; // ← غيّر النوع

  AiChatCubit() : super(AiChatInitial());

  Future<void> sendSymptoms(String message, {String? imagePath}) async {
    history.add(AiChatMessage(message: message, isUser: true)); // ← غيّر النوع

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
        AiChatMessage(
          // ← غيّر النوع
          message: response.message,
          isUser: false,
          doctors:
              response.recommendedDoctors, // ← List<Doctor> من الـ response
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
      history = decoded
          .map((e) => AiChatMessage.fromJson(e))
          .toList(); // ← غيّر النوع
      emit(AiChatSuccess(List.from(history)));
    }
  }

  void clearHistory() {
    history.clear(); // ← كانت ناقصة
    saveHistory(); // ← امسح من الـ SharedPreferences
    emit(AiChatInitial());
  }
}
