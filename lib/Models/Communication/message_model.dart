// message_model.dart
class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final String createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}

// paginated_messages.dart
class PaginatedMessages {
  final List<Message> items;
  final int pageNumber;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;

  PaginatedMessages({
    required this.items,
    required this.pageNumber,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PaginatedMessages.fromJson(Map<String, dynamic> json) {
    return PaginatedMessages(
      items: (json['items'] as List).map((m) => Message.fromJson(m)).toList(),
      pageNumber: json['pageNumber'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
