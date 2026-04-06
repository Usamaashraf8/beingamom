class Message {
  final int? id;
  final String content;
  final bool isUser;
  final DateTime createdAt;

  Message({
    this.id,
    required this.content,
    required this.isUser,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isUser: json['is_user'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'is_user': isUser,
    };
  }
}