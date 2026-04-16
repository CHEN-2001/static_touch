class LiveDataModel {
  final String totalHours;
  final int totalCount;
  final List<LiveHistoryRecord> history;

  LiveDataModel({required this.totalHours, required this.totalCount, required this.history});
}

class LiveHistoryRecord {
  final String id;
  final String title;
  final String timeLabel; // 例如：昨天 8:00
  final int durationMinutes;

  LiveHistoryRecord({required this.id, required this.title, required this.timeLabel, required this.durationMinutes});
}
