import 'package:static_touch/pages/home/home_provider.dart';

class MeditationDetailModel {
  final String title;
  final ScheduleStatus status;
  final DateTime startTime; // 对应你 HomeProvider 里的 startTime

  // 已结束专有字段
  final DateTime? actualEndTime;
  final int viewers;
  final String replayUrl;

  MeditationDetailModel({
    required this.title,
    required this.status,
    required this.startTime,
    this.actualEndTime,
    this.viewers = 0,
    this.replayUrl = '',
  });

  // 严谨逻辑：计算未开始(upcoming)是否超时
  String get overdueDisplay {
    if (status != ScheduleStatus.upcoming) return "";
    final now = DateTime.now();
    if (now.isAfter(startTime)) {
      final diff = now.difference(startTime).inMinutes;
      return "已超时 $diff 分钟";
    }
    return "准时开启";
  }

  // 严谨逻辑：计算已结束(finished)的总时长
  String get durationDisplay {
    if (actualEndTime == null) return "0分钟";
    final diff = actualEndTime!.difference(startTime);
    return "${diff.inMinutes}分钟";
  }

  String formatTime(DateTime time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
