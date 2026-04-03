import 'package:flutter/material.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'models/meditation_schedule_model.dart';

class MeditationDetailProvider extends ChangeNotifier {
  MeditationScheduleModel? _detail;
  MeditationScheduleModel? get detail => _detail;

  bool _isReminded = false;
  bool get isReminded => _isReminded;

  void loadDetail(Map<String, dynamic> params) {
    final status = params['status'] as ScheduleStatus;
    final title = params['title'] ?? "未知修行";
    final startTime = params['startTime'] as DateTime? ?? DateTime.now();

    if (status == ScheduleStatus.finished) {
      // 模拟已结束的数据
      _detail = MeditationScheduleModel(
        title: title,
        status: status,
        expectedStartTime: startTime,
        actualStartTime: startTime.add(const Duration(minutes: 5)), // 迟到5分钟开始
        actualEndTime: startTime.add(const Duration(minutes: 50)),
        viewers: 356,
      );
    } else {
      // 模拟未开始的数据
      _detail = MeditationScheduleModel(title: title, status: status, expectedStartTime: startTime);
    }
    notifyListeners();
  }

  void toggleRemind() {
    _isReminded = !_isReminded;
    notifyListeners();
  }
}
