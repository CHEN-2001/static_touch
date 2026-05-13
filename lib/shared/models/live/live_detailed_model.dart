import 'package:static_touch/shared/enum/live_status_enum.dart';

class MeditationScheduleModel {
  final int id;
  final String title;
  final LiveStatus status;
  final DateTime expectedStartTime;
  final String description;

  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final int viewers;

  MeditationScheduleModel({
    required this.id,
    required this.title,
    required this.status,
    required this.expectedStartTime,
    this.description = "暂无修行简介。",
    this.actualStartTime,
    this.actualEndTime,
    this.viewers = 0,
  });

  String formatTime(DateTime? time) {
    if (time == null) return "--:--";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String get durationText {
    if (actualStartTime == null || actualEndTime == null) return "0分钟";
    return "${actualEndTime!.difference(actualStartTime!).inMinutes}分钟";
  }

  int get timeoutMinutes {
    // 🚀 规范 2：判断是否为 preparing (准备中)
    if (status != LiveStatus.preparing) return 0;
    final now = DateTime.now();
    if (now.isAfter(expectedStartTime)) {
      return now.difference(expectedStartTime).inMinutes;
    }
    return 0;
  }
}
