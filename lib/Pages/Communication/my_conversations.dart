// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/Bloc/Chat_Bloc/chat_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Chat_Bloc/chat_event.dart';
import 'package:healthcareapp_try1/Bloc/Message_Bloc/message_bloc.dart';
import 'package:healthcareapp_try1/Pages/Communication/chat_details_page.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyConversations extends StatefulWidget {
  const MyConversations({super.key});

  @override
  State<MyConversations> createState() => _MyConversationsState();
}

class _MyConversationsState extends State<MyConversations> {
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.black87;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.5) : Colors.grey.shade500;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200;
  Color get _unreadDot => _isDark ? Colors.blue.shade300 : Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Conversations",
          style: TextStyle(
            fontFamily: 'Cotta',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => ChatBloc(ChatService())..add(FetchChatsEvent()),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return Skeletonizer(
                enabled: true,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: const CircleAvatar(radius: 28),
                        title: Container(
                          height: 12,
                          width: 100,
                          color: Colors.grey,
                        ),
                        subtitle: Container(
                          height: 10,
                          width: 150,
                          margin: const EdgeInsets.only(top: 6),
                          color: Colors.grey,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 30,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return Center(
                  child: Text(
                    "No conversations yet",
                    style: TextStyle(fontSize: 16, color: _secondaryText),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: state.chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  final bool isUnread = !chat.isLastMessageFromMe;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _borderColor, width: 0.5),
                      boxShadow: _isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (ctx) =>
                                  MessageBloc(ChatService())
                                    ..add(LoadMessages(chat.id)),
                              child: ChatDetailsPage(
                                chatId: chat.id,
                                chatName: chat.name,
                              ),
                            ),
                          ),
                        ).then((_) {
                          context.read<ChatBloc>().add(FetchChatsEvent());
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(chat.pictureUrl),
                            backgroundColor: _isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.grey.shade200,
                          ),
                          if (isUnread)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: _unreadDot,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _cardBg, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        chat.name,
                        style: TextStyle(
                          fontWeight: isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                          color: _primaryText,
                          fontFamily: 'Agency',
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          chat.lastMessage ?? "Start a conversation",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnread ? _primaryText : _secondaryText,
                            fontSize: 12,
                            fontWeight: isUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                            fontFamily: 'Agency',
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chat.lastMessageAt?.substring(11, 16) ?? "",
                            style: TextStyle(
                              fontSize: 11,
                              color: isUnread ? _unreadDot : _secondaryText,
                              fontFamily: 'Agency',
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _unreadDot,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(width: 8, height: 8),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Something went wrong",
                      style: TextStyle(
                        color: _primaryText,
                        fontFamily: 'Agency',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 12,
                        fontFamily: 'Agency',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ChatBloc>().add(FetchChatsEvent()),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
