import 'dart:async';
import 'package:static_touch/enum/live_status_enum.dart';
import 'package:static_touch/models/live_detailed_model.dart';
import 'package:static_touch/models/live_item_model.dart';

class MeditationService {
  // 获取详情数据（模拟 API）
  Future<MeditationScheduleModel> fetchDetailFromApi(LiveItemModel item) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟网络请求

    final status = item.status;
    final title = item.title;
    final startTime = item.startTime;
    if (status == LiveStatusEnum.finished) {
      return MeditationScheduleModel(
        title: title,
        status: status,
        expectedStartTime: startTime,
        actualStartTime: startTime.add(const Duration(minutes: 5)),
        actualEndTime: startTime.add(const Duration(minutes: 50)),
        viewers: 356,
      );
    } else {
      return MeditationScheduleModel(title: title, status: status, expectedStartTime: startTime);
    }
  }

  // 设置提醒（模拟 API 调用）
  Future<bool> setReminder(String id, bool isReminded) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // 成功
  }
}
