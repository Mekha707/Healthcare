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
  // ─── Theme helpers (identical to PatientProfilePage) ─────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : const Color(0xfff4f7fb);
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color get _primary => _isDark ? Colors.white : const Color(0xff0d1b4b);
  Color get _secondary => _isDark ? Colors.white60 : Colors.grey.shade600;
  Color get _divider => _isDark ? Colors.white10 : Colors.grey.shade100;
  Color get _iconBg => _isDark
      ? Colors.blue.shade900.withOpacity(0.35)
      : const Color(0xffe8f0fe);
  BoxShadow get _cardShadow => BoxShadow(
    color: _isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
    blurRadius: 20,
    offset: const Offset(0, 6),
  );
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => ChatBloc(ChatService())..add(FetchChatsEvent()),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) return _buildSkeleton();
            if (state is ChatLoaded) return _buildLoaded(context, state);
            if (state is ChatError) return _buildError(context, state.message);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ── Hero banner ───────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56, bottom: 28),
      decoration: BoxDecoration(
        color: _cardBg,
        boxShadow: [_cardShadow],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_accent, _accent.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: _cardBg),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: _iconBg,
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 28,
                  color: _accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Conversations',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primary,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withOpacity(0.20)),
            ),
            child: Text(
              'Your messages',
              style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loaded state ──────────────────────────────────────────────────────────
  Widget _buildLoaded(BuildContext context, ChatLoaded state) {
    if (state.chats.isEmpty) {
      return Column(
        children: [
          _buildHeroBanner(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 36,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      color: _secondary,
                      fontSize: 15,
                      fontFamily: 'Agency',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeroBanner()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chat = state.chats[index];
              final bool isUnread = !chat.isLastMessageFromMe;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildChatCard(context, chat, isUnread),
              );
            }, childCount: state.chats.length),
          ),
        ),
      ],
    );
  }

  // ── Chat card ─────────────────────────────────────────────────────────────
  Widget _buildChatCard(BuildContext context, dynamic chat, bool isUnread) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (ctx) =>
                  MessageBloc(ChatService())..add(LoadMessages(chat.id)),
              child: ChatDetailsPage(chatId: chat.id, chatName: chat.name),
            ),
          ),
        ).then((_) {
          context.read<ChatBloc>().add(FetchChatsEvent());
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [_cardShadow],
        ),
        child: Row(
          children: [
            // ── Avatar with unread ring / dot ─────────────────────
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnread ? _accent.withOpacity(0.50) : _divider,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(chat.pictureUrl),
                    backgroundColor: _iconBg,
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: _cardBg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // ── Name + last message ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Cotta',
                      color: _primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage ?? 'Start a conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isUnread ? _primary : _secondary,
                      fontSize: 12,
                      fontWeight: isUnread
                          ? FontWeight.w500
                          : FontWeight.normal,
                      fontFamily: 'Agency',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ── Time + unread indicator ───────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat.lastMessageAt?.substring(11, 16) ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: isUnread ? _accent : _secondary,
                    fontFamily: 'Agency',
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(width: 8, height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────────────────────
  Widget _buildSkeleton() {
    final sk = _isDark
        ? AppColors.bgDark.withOpacity(0.85)
        : Colors.grey.shade100;

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: _isDark ? AppColors.surfaceDark : const Color(0xFFE0E0E0),
        highlightColor: _isDark ? AppColors.bgDark : const Color(0xFFF5F5F5),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeroBanner()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [_cardShadow],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 28, backgroundColor: sk),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 130,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: sk,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 200,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: sk,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 30,
                              height: 10,
                              decoration: BoxDecoration(
                                color: sk,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: sk,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                childCount: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Column(
      children: [
        _buildHeroBanner(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 36,
                    color: _isDark ? Colors.red.shade300 : Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: _primary,
                    fontFamily: 'Cotta',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _secondary,
                      fontSize: 12,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.read<ChatBloc>().add(FetchChatsEvent()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _accent.withOpacity(0.25)),
                    ),
                    child: Text(
                      'Try again',
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
