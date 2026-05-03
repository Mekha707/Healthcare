import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  HubConnection? _hubConnection;

  final String hubUrl = "https://healthcare52.runasp.net/healthcare-hub";

  Future<void> initHub(
    String token,
    Function(dynamic) onMessageReceived,
  ) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async => token,
            transport: HttpTransportType.webSockets,
            skipNegotiation: true,
            logging: (level, message) =>
                print('SignalR Log ($level): $message'),
          ),
        )
        .build();

    _hubConnection?.onclose(
      (error) => print("❌ SignalR Connection Closed: $error"),
    );

    _hubConnection?.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onMessageReceived(arguments[0]);
      }
    });

    try {
      await _hubConnection?.start();
      print("🚀 SignalR Connected Successfully");
    } catch (e) {
      print("🔌 SignalR Start Error: $e");
    }
  }

  // --- السطور اللي كانت ناقصة عندك ومسببة الأخطاء ---

  // 1. دالة الانضمام لغرفة الشات
  Future<void> joinChat(String chatId) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      await _hubConnection?.invoke("JoinChat", args: [chatId]);
      print("✅ Joined Chat Room: $chatId");
    } else {
      print("⚠️ Cannot join chat: SignalR not connected");
    }
  }

  // 2. دالة إرسال الرسالة
  Future<void> sendMessage(String chatId, String content) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      // تأكد إن "SendMessage" هو نفس الاسم في الباك-إند (Hub)
      await _hubConnection?.invoke("SendMessage", args: [chatId, content]);
    } else {
      print("⚠️ Cannot send message: SignalR not connected");
    }
  }

  // 3. دالة إغلاق الاتصال
  void stopConnection() {
    if (_hubConnection != null) {
      _hubConnection!.stop();
      print("🛑 SignalR Connection Stopped");
    }
  }
}
