import 'package:flutter/material.dart';

class ScheduleItem {
  final String time;
  final String title;
  final String status; // '已结束', '进行中', '未开始'
  final bool canAction;

  ScheduleItem({required this.time, required this.title, required this.status, required this.canAction});
}

class HomeProvider with ChangeNotifier {
  // 模拟数据
  int totalDuration = 128;
  String userName = "用户名";
  String dailyQuote = "每日语旬预留，每日语旬预留。";

  List<ScheduleItem> scheduleItems = [
    ScheduleItem(time: '07:00', title: '直播标题一', status: '已结束', canAction: false),
    ScheduleItem(time: '08:00', title: '直播标题二', status: '进行中', canAction: true),
    ScheduleItem(time: '09:00', title: '直播标题三', status: '未开始', canAction: true),
  ];

  // 模拟刷新数据的方法
  void refreshData() {
    totalDuration += 1;
    notifyListeners();
  }
}
