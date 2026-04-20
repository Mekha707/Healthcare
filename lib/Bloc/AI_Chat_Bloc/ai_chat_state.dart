abstract class AiChatState {}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {}

class AiChatSuccess extends AiChatState {
  final List<dynamic> allMessages; // دي هتشيل الـ ChatResponse والرسائل اليدوية
  AiChatSuccess(this.allMessages);
}

class AiChatError extends AiChatState {
  final String message;
  AiChatError(this.message);
}
