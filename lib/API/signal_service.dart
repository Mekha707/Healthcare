import 'dart:async';

import 'package:healthcareapp_try1/API/notification_service.dart';
import 'package:healthcareapp_try1/Models/Communication/message_model.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  SignalRService._internal();

  static final SignalRService _instance = SignalRService._internal();

  factory SignalRService() => _instance;

  HubConnection? _hubConnection;
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();

  final String hubUrl = 'https://healthcare52.runasp.net/healthcare-hub';

  String? _currentUserId;
  String? _activeChatId;

  Stream<Message> get messagesStream => _messageController.stream;

  Future<void> initHub(String token, {String? currentUserId}) async {
    if (_hubConnection?.state == HubConnectionState.connected ||
        _hubConnection?.state == HubConnectionState.connecting) {
      _currentUserId = currentUserId ?? _currentUserId;
      return;
    }

    _currentUserId = currentUserId ?? _currentUserId;

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async => token,
            transport: HttpTransportType.webSockets,
            skipNegotiation: true,
            logging: (level, message) {
              print('SignalR Log ($level): $message');
            },
          ),
        )
        .build();

    _hubConnection?.onclose((error) {
      print('SignalR connection closed: $error');
    });

    _hubConnection?.on('ReceiveMessage', (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final rawMessage = arguments.first;
      if (rawMessage is! Map<String, dynamic>) return;

      final message = Message.fromJson(rawMessage);
      _messageController.add(message);
      _maybeShowChatNotification(message);
    });

    try {
      await _hubConnection?.start();
      print('SignalR connected successfully');
    } catch (e) {
      print('SignalR start error: $e');
    }
  }

  void setActiveChat(String? chatId) {
    _activeChatId = chatId;
  }

  Future<void> joinChat(String chatId) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      await _hubConnection?.invoke('JoinChat', args: [chatId]);
      print('Joined chat room: $chatId');
    } else {
      print('Cannot join chat: SignalR not connected');
    }
  }

  Future<void> sendMessage(String chatId, String content) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      await _hubConnection?.invoke('SendMessage', args: [chatId, content]);
    } else {
      print('Cannot send message: SignalR not connected');
    }
  }

  void _maybeShowChatNotification(Message message) {
    if (message.senderId == _currentUserId) return;
    if (_activeChatId != null && message.chatId == _activeChatId) return;

    NotificationService.showChatNotification(
      id: message.id.hashCode,
      title: message.senderName.isNotEmpty ? message.senderName : 'New message',
      body: message.content,
      payload: message.chatId,
    );
  }

  Future<void> stopConnection() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      print('SignalR connection stopped');
    }
  }
}
