// ignore_for_file: unnecessary_null_comparison, dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/API/signal_service.dart';
import 'package:healthcareapp_try1/Bloc/Message_Bloc/message_bloc.dart';
import 'package:healthcareapp_try1/Models/Communication/message_model.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  late MessageBloc _bloc;
  StreamSubscription<Message>? _messageSubscription;
  String myid = "";

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : const Color(0xFFF7F9FC);
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.black87;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.5) : Colors.grey.shade500;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200;
  Color get _bubbleMe => _isDark ? Colors.blue.shade700 : Colors.blue;
  Color get _bubbleOther => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _inputBg => _isDark ? AppColors.surfaceDark : Colors.white;

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

    await _signalRService.initHub(token, currentUserId: myid);
    _signalRService.setActiveChat(widget.chatId);

    await _messageSubscription?.cancel();
    _messageSubscription = _signalRService.messagesStream.listen((newMessage) {
      final belongsToCurrentChat =
          newMessage.chatId == null || newMessage.chatId == widget.chatId;

      if (mounted && belongsToCurrentChat) {
        _bloc.add(ReceiveNewMessage(newMessage));
      }
    });

    await _signalRService.joinChat(widget.chatId);
  }

  @override
  void dispose() {
    _signalRService.setActiveChat(null);
    _messageSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
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
      elevation: 0.5,
      backgroundColor: _cardBg,
      titleSpacing: 0,
      title: Row(
        children: [
          if (widget.imageUrl != null) ...[
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.imageUrl!),
              backgroundColor: _isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.grey.shade200,
            ),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Agency',
                  color: _primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is MessageLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _isDark ? Colors.blue.shade300 : Colors.blue,
            ),
          );
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
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.data.items.length,
            itemBuilder: (context, index) {
              final msg = state.data.items[index];
              final bool isMe = msg.senderId == myid;
              return _buildMessageBubble(msg, isMe);
            },
          );
        }

        return Center(
          child: Text(
            "Start the conversation...",
            style: TextStyle(
              color: _secondaryText,
              fontFamily: 'Agency',
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(Message msg, bool isMe) {
    final timeText = msg.createdAt.length >= 16
        ? msg.createdAt.substring(11, 16)
        : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 12,
          right: isMe ? 12 : 60,
          top: 3,
          bottom: 3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? _bubbleMe : _bubbleOther,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: _borderColor, width: 0.5),
          boxShadow: _isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: TextStyle(
                color: isMe ? Colors.white : _primaryText,
                fontSize: 13,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white.withOpacity(0.6) : _secondaryText,
                fontFamily: 'Agency',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _inputBg,
        border: Border(top: BorderSide(color: _borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _borderColor, width: 0.5),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                  fontSize: 13,
                  color: _primaryText,
                  fontFamily: 'Agency',
                ),
                decoration: InputDecoration(
                  hintText: "Write a message...",
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: _secondaryText,
                    fontFamily: 'Agency',
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              final text = _messageController.text.trim();
              if (text.isEmpty) return;
              _signalRService.sendMessage(widget.chatId, text);
              _messageController.clear();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isDark ? Colors.blue.shade700 : Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
