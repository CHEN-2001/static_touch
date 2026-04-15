import 'package:static_touch/enum/live_status_enum.dart';

class MeditationScheduleModel {
  final int id;
  final String title;
  final LiveStatusEnum status;
  final DateTime expectedStartTime;
  final String description;

  // 已结束特有字段
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

  // 格式化时间工具
  String formatTime(DateTime? time) {
    if (time == null) return "--:--";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  // 计算时长
  String get durationText {
    if (actualStartTime == null || actualEndTime == null) return "0分钟";
    return "${actualEndTime!.difference(actualStartTime!).inMinutes}分钟";
  }

  // 计算超时
  int get timeoutMinutes {
    if (status != LiveStatusEnum.upcoming) return 0;
    final now = DateTime.now();
    if (now.isAfter(expectedStartTime)) {
      return now.difference(expectedStartTime).inMinutes;
    }
    return 0;
  }
}
