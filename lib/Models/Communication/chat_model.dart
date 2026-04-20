class Chat {
  final String id;
  final String name;
  final String pictureUrl;
  final String? lastMessage;
  final String? lastMessageAt;
  final bool isLastMessageFromMe;

  Chat({
    required this.id,
    required this.name,
    required this.pictureUrl,
    this.lastMessage,
    this.lastMessageAt,
    required this.isLastMessageFromMe,
  });

  // Factory لتحويل الـ JSON لـ Object
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      pictureUrl: json['pictureUrl'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'],
      isLastMessageFromMe: json['isLastMessageFromMe'],
    );
  }
}
