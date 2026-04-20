// chat_event.dart
import 'package:healthcareapp_try1/Models/Communication/chat_model.dart';

abstract class ChatEvent {}

class FetchChatsEvent extends ChatEvent {}

// chat_state.dart
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  ChatLoaded(this.chats);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
