class LiveDataModel {
  final String totalHours;
  final int totalCount;
  final List<LiveHistoryRecord> history;

  LiveDataModel({required this.totalHours, required this.totalCount, required this.history});

  factory LiveDataModel.fromJson(Map<String, dynamic> json) {
    return LiveDataModel(
      totalHours: json['totalHours']?.toString() ?? '0',
      totalCount: json['totalCount'] ?? 0,
      history: (json['history'] as List?)?.map((e) => LiveHistoryRecord.fromJson(e)).toList() ?? [],
    );
  }
}

class LiveHistoryRecord {
  final String id;
  final String title;
  final String timeLabel;
  final int durationMinutes;

  LiveHistoryRecord({required this.id, required this.title, required this.timeLabel, required this.durationMinutes});

  factory LiveHistoryRecord.fromJson(Map<String, dynamic> json) {
    return LiveHistoryRecord(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '未知直播',
      timeLabel: json['timeLabel'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
    );
  }
}
