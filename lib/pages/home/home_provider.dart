import 'package:flutter/material.dart';

/// 1. 使用枚举定义状态，而不是字符串
enum ScheduleStatus { finished, ongoing, upcoming }

class ScheduleItem {
  final String id; // 唯一标识，方便列表渲染优化
  final DateTime startTime; // 使用 DateTime 处理时间，后端传时间戳
  final String title;
  final ScheduleStatus status;

  ScheduleItem({required this.id, required this.startTime, required this.title, required this.status});

  // --- 计算属性：UI 逻辑封装在这里，不要写在 Widget 里 ---

  // 格式化时间：把 DateTime 转为 07:00 这种格式
  String get timeDisplay =>
      "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";

  // 根据状态返回对应的 UI 文字
  String get statusText {
    switch (status) {
      case ScheduleStatus.finished:
        return '已结束';
      case ScheduleStatus.ongoing:
        return '进行中';
      case ScheduleStatus.upcoming:
        return '未开始';
    }
  }

  // 是否可以点击操作
  bool get canAction => status != ScheduleStatus.finished;

  // 状态对应的颜色（配合刚才的 UI 组件）
  Color get statusColor {
    switch (status) {
      case ScheduleStatus.finished:
        return const Color(0xFFD3D3D3); // 灰色
      case ScheduleStatus.ongoing:
        return const Color(0xFF6B8E23); // 橄榄绿
      case ScheduleStatus.upcoming:
        return const Color(0xFFDAA520); // 琥珀金
    }
  }
}

class HomeProvider with ChangeNotifier {
  // 模拟基础信息
  int totalDuration = 128;
  String userName = "用户名";
  String dailyQuote = "每日语旬预留，每日语旬预留。";

  // 模拟列表数据
  // 生产环境下，这里应该是从 API 获取后再转换成 ScheduleItem 对象
  final List<ScheduleItem> _scheduleItems = [
    ScheduleItem(
      id: '1',
      startTime: DateTime(2026, 4, 1, 7, 0), // 07:00
      title: '直播标题一',
      status: ScheduleStatus.finished,
    ),
    ScheduleItem(
      id: '2',
      startTime: DateTime(2026, 4, 1, 8, 0), // 08:00
      title: '直播标题二',
      status: ScheduleStatus.ongoing,
    ),
    ScheduleItem(
      id: '3',
      startTime: DateTime(2026, 4, 1, 9, 0), // 09:00
      title: '直播标题三',
      status: ScheduleStatus.upcoming,
    ),
  ];

  // 只读获取列表
  List<ScheduleItem> get scheduleItems => _scheduleItems;

  // 模拟刷新数据的方法
  void refreshData() {
    totalDuration += 1;

    // 模拟数据变动：比如把第一个变成进行中
    // 实际开发中这里会调用 Dio 等网络库请求后端接口
    notifyListeners();
  }

  /// 后期对接后端 API 的逻辑预留
  /// void updateFromApi(List jsonList) {
  ///   _scheduleItems = jsonList.map((json) => ScheduleItem.fromJson(json)).toList();
  ///   notifyListeners();
  /// }
}
