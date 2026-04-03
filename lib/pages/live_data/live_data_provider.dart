import 'package:flutter/material.dart';
import 'models/live_data_model.dart';

class LiveDataProvider extends ChangeNotifier {
  LiveDataModel? _stats;
  LiveDataModel? get stats => _stats;

  void fetchStats() {
    // 模拟数据请求
    _stats = LiveDataModel(
      totalHours: "1,220",
      totalCount: 365,
      history: [
        LiveHistoryRecord(id: "101", title: "直播标题二", timeLabel: "昨天 8:00", durationMinutes: 32),
        LiveHistoryRecord(id: "102", title: "直播标题一", timeLabel: "3月2日", durationMinutes: 60),
      ],
    );
    notifyListeners();
  }
}
