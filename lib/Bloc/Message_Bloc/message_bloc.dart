import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/Models/Communication/message_model.dart';

// --- Events ---
abstract class MessageEvent {}

class LoadMessages extends MessageEvent {
  final String chatId;
  final int page;
  LoadMessages(this.chatId, {this.page = 1});
}

class ReceiveNewMessage extends MessageEvent {
  final Message message;
  ReceiveNewMessage(this.message);
}

// --- States ---
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final PaginatedMessages data;
  MessageLoaded(this.data);
}

class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}

// --- Bloc ---
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatService chatService;

  MessageBloc(this.chatService) : super(MessageInitial()) {
    on<LoadMessages>((event, emit) async {
      if (state is MessageLoaded) return;

      emit(MessageLoading());
      try {
        final data = await chatService.fetchMessages(event.chatId, event.page);
        emit(MessageLoaded(data));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<ReceiveNewMessage>((event, emit) {
      if (state is MessageLoaded) {
        final currentState = state as MessageLoaded;

        // final alreadyExists = currentState.data.items.any(
        //   (m) =>
        //       m.id == event.message.id ||
        //       (m.senderId == event.message.senderId &&
        //           m.content == event.message.content &&
        //           m.id.startsWith('temp_')),
        // );

        // if (alreadyExists) return;

        // // إضافة الرسالة الجديدة للبداية (بسبب reverse: true)
        // final updatedItems = List<Message>.from(currentState.data.items)
        //   ..insert(0, event.message);
        final updatedItems = List<Message>.from(currentState.data.items)
          ..add(event.message);

        emit(
          MessageLoaded(
            PaginatedMessages(
              items: updatedItems,
              pageNumber: currentState.data.pageNumber,
              totalCount: currentState.data.totalCount + 1,
              totalPages: currentState.data.totalPages,
              hasNextPage: currentState.data.hasNextPage,
            ),
          ),
        );
      }
    });
  }
}
