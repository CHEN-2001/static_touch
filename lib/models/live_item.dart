import 'package:static_touch/enum/live_static.dart';

class LiveItem {
  final String id;
  final String title;
  final DateTime startTime;
  final LiveStatus status;

  LiveItem({required this.id, required this.title, required this.startTime, required this.status});

  String get timeDisplay =>
      "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";

  factory LiveItem.fromJson(Map<String, dynamic> json) {
    return LiveItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch((json['start_time'] ?? 0) * 1000),
      status: LiveStatus.fromInt(json['status'] ?? 0),
    );
  }
}
