import 'dart:async';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/models/live/live_detailed_model.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';

class MeditationService {
  // 获取详情数据（模拟 API）
  Future<MeditationScheduleModel> fetchDetailFromApi(LiveItemModel item) async {
    // 🚀 核心修复 1：将 String 类型的 id 安全转换为 int 格式
    final int parsedId = int.tryParse(item.id) ?? 0;

    final status = item.status;
    final title = item.title;

    // 🚀 核心修复 2：因为模型已经没有 startTime 了，用当前时间代替模拟
    final startTime = DateTime.now();

    if (status == LiveStatus.ended) {
      return MeditationScheduleModel(
        id: parsedId, // 使用转换后的 int
        title: title,
        status: status,
        expectedStartTime: startTime,
        actualStartTime: startTime.add(const Duration(minutes: 5)),
        actualEndTime: startTime.add(const Duration(minutes: 50)),
        viewers: 356,
      );
    } else {
      return MeditationScheduleModel(
        id: parsedId, // 使用转换后的 int
        title: title,
        status: status,
        expectedStartTime: startTime,
      );
    }
  }

  // 设置提醒（模拟 API 调用）
  Future<bool> setReminder(int id, bool isReminded) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // 成功
  }
}
