class Message {
  final String id;
  final String? chatId;
  final String senderId;
  final String senderName;
  final String content;
  final String createdAt;

  Message({
    required this.id,
    this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: (json['id'] ?? json['Id'] ?? '').toString(),
      chatId: (json['chatId'] ?? json['ChatId'])?.toString(),
      senderId: (json['senderId'] ?? json['SenderId'] ?? '').toString(),
      senderName: (json['senderName'] ?? json['SenderName'] ?? '').toString(),
      content: (json['content'] ?? json['Content'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? json['CreatedAt'] ?? '').toString(),
    );
  }
}

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
