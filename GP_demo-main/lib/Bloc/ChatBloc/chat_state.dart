abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<dynamic> allMessages; // دي هتشيل الـ ChatResponse والرسائل اليدوية
  ChatSuccess(this.allMessages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
