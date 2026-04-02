class NoticeModel {
  final String id;
  final String type; // '系统' 或 '提醒'
  final String title;
  final String content;
  final String time;
  bool isRead;

  NoticeModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
  });
}
