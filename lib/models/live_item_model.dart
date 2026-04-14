import 'package:static_touch/enum/live_status_enum.dart';

class LiveItemModel {
  final String id;
  final String title;
  final DateTime startTime;
  final LiveStatusEnum status;

  LiveItemModel({required this.id, required this.title, required this.startTime, required this.status});

  String get timeDisplay =>
      "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";

  factory LiveItemModel.fromJson(Map<String, dynamic> json) {
    return LiveItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch((json['start_time'] ?? 0) * 1000),
      status: LiveStatusEnum.fromInt(json['status'] ?? 0),
    );
  }
}
