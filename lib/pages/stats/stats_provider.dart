import 'package:flutter/material.dart';
import 'models/stats_model.dart';

class StatsProvider with ChangeNotifier {
  StatsModel get stats => StatsModel(
    totalDays: 100,
    streakDays: 10,
    totalMinutes: 3230,
    thisWeekMinutes: 30,
    weeklyTrend: [
      ChartData(label: '03.28', minutes: 80),
      ChartData(label: '03.29', minutes: 45),
      ChartData(label: '03.30', minutes: 60),
      ChartData(label: '03.31', minutes: 85),
      ChartData(label: '04.01', minutes: 50),
      ChartData(label: '04.02', minutes: 70),
      // 🚀 “今日”永远在最后，符合时间逻辑
      ChartData(label: '今日', minutes: 65, isToday: true),
    ],
  );
}
