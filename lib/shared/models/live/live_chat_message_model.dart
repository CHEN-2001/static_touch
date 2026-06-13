class LiveChatMessageModel {
  final String type;
  final int? senderId;
  final String? senderName;
  final String content;
  final int timestamp;

  LiveChatMessageModel({
    required this.type,
    this.senderId,
    this.senderName,
    required this.content,
    required this.timestamp,
  });

  factory LiveChatMessageModel.fromJson(Map<String, dynamic> json) {
    return LiveChatMessageModel(
      type: json['type'] ?? 'CHAT',
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
