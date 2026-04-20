// chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/Bloc/Chat_Bloc/chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;

  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<FetchChatsEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await chatService.fetchChats();
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
