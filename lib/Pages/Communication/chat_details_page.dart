// // ignore_for_file: unused_field

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/API/chat_service.dart';
// import 'package:healthcareapp_try1/API/signal_service.dart';
// import 'package:healthcareapp_try1/Bloc/Message_Bloc/message_bloc.dart';
// import 'package:healthcareapp_try1/Models/Communication/message_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatDetailsPage extends StatefulWidget {
//   final String chatId;
//   final String chatName;
//   final String? imageUrl;

//   const ChatDetailsPage({
//     super.key,
//     required this.chatId,
//     required this.chatName,
//     this.imageUrl,
//   });

//   @override
//   State<ChatDetailsPage> createState() => _ChatDetailsPageState();
// }

// class _ChatDetailsPageState extends State<ChatDetailsPage> {
//   final SignalRService _signalRService = SignalRService();
//   final TextEditingController _messageController = TextEditingController();
//   late MessageBloc _bloc;
//   String myid = "";

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _bloc = context.read<MessageBloc>();
//       _setupSignalR();
//     });
//   }

//   void _setupSignalR() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? "";
//     myid = prefs.getString('userId') ?? "";

//    await _signalRService.initHub(token, (newMessageJson) {
//       final newMessage = Message.fromJson(newMessageJson);
//       _bloc.add(ReceiveNewMessage(newMessage)); // ← استخدم الـ reference المحفوظ
//     });

//     await _signalRService.joinChat(widget.chatId);
//   }

//   @override
//   void dispose() {
//     _signalRService.stopConnection();
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // وضع الـ BlocProvider هنا يضمن استقرار الـ State
//     return BlocProvider(
//       create: (context) =>
//           MessageBloc(ChatService())..add(LoadMessages(widget.chatId)),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF7F9FC),
//         appBar: _buildAppBar(),
//         body: FutureBuilder<SharedPreferences>(
//           future: SharedPreferences.getInstance(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             myid = snapshot.data!.getString('userId') ?? "";

//             return Column(
//               children: [
//                 Expanded(child: _buildMessagesList(myid)),
//                 _buildInputArea(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Row(
//         children: [
//           if (widget.imageUrl != null)
//             CircleAvatar(
//               radius: 18,
//               backgroundImage: NetworkImage(widget.imageUrl!),
//             ),
//           const SizedBox(width: 10),
//           Text(widget.chatName),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessagesList(String myId) {
//     return BlocBuilder<MessageBloc, MessageState>(
//       builder: (context, state) {
//         if (state is MessageLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (state is MessageLoaded) {
//           return ListView.builder(
//             reverse: true, // عشان الرسايل الجديدة تظهر تحت وفوق الكيبورد
//             itemCount: state.data.items.length,
//             itemBuilder: (context, index) {
//               final msg = state.data.items[index];
//               final bool isMe = msg.senderId == myId;
//               return _buildMessageBubble(msg, isMe);
//             },
//           );
//         }
//         return const Center(child: Text("ابدأ الدردشة..."));
//       },
//     );
//   }

//   Widget _buildMessageBubble(Message msg, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           msg.content,
//           style: TextStyle(color: isMe ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController, // الربط بالكنترولر
//               decoration: const InputDecoration(
//                 hintText: "اكتب رسالة...",
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.blue),
//             onPressed: () {
//               if (_messageController.text.isNotEmpty) {
//                 final text = _messageController.text;
//                 _signalRService.sendMessage(widget.chatId, text);

//                 final temporaryMessage = Message(
//                   id: DateTime.now().millisecondsSinceEpoch
//                       .toString(), // ID مؤقت
//                   content: text,
//                   senderId:
//                       myid, // الـ ID بتاعك اللي جبناه من الـ SharedPreferences
//                   createdAt: DateTime.now().toString(),
//                   senderName: '',
//                 );

//                 context.read<MessageBloc>().add(
//                   ReceiveNewMessage(temporaryMessage),
//                 );

//                 _messageController.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/API/signal_service.dart';
import 'package:healthcareapp_try1/Bloc/Message_Bloc/message_bloc.dart';
import 'package:healthcareapp_try1/Models/Communication/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String? imageUrl;

  const ChatDetailsPage({
    super.key,
    required this.chatId,
    required this.chatName,
    this.imageUrl,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final SignalRService _signalRService = SignalRService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // ← هنا
  late MessageBloc _bloc;
  String myid = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc = context.read<MessageBloc>();
      _setupSignalR();
    });
  }

  void _setupSignalR() async {
    final prefs = await SharedPreferences.getInstance();
    myid = prefs.getString('userId') ?? "";
    final token = prefs.getString('token') ?? "";

    await _signalRService.initHub(token, (newMessageJson) {
      final newMessage = Message.fromJson(newMessageJson);
      if (mounted) {
        _bloc.add(ReceiveNewMessage(newMessage));
      }
    });

    await _signalRService.joinChat(widget.chatId);
  }

  @override
  void dispose() {
    _signalRService.stopConnection();
    _messageController.dispose();
    _scrollController.dispose(); // ← dispose هنا
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          if (widget.imageUrl != null)
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.imageUrl!),
            ),
          const SizedBox(width: 10),
          Text(widget.chatName),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is MessageLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is MessageLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
          return ListView.builder(
            itemCount: state.data.items.length,
            itemBuilder: (context, index) {
              final msg = state.data.items[index];
              final bool isMe = msg.senderId == myid;
              return _buildMessageBubble(msg, isMe);
            },
          );
        }
        return const Center(child: Text("ابدأ الدردشة..."));
      },
    );
  }

  Widget _buildMessageBubble(Message msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "اكتب رسالة...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isEmpty) return;

              _signalRService.sendMessage(widget.chatId, text);

              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
