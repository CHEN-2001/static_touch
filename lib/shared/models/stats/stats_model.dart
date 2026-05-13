class StatsModel {
  final int totalDays;
  final int streakDays;
  final int totalMinutes;
  final int thisWeekMinutes;
  final List<ChartData> weeklyTrend;

  StatsModel({
    required this.totalDays,
    required this.streakDays,
    required this.totalMinutes,
    required this.thisWeekMinutes,
    required this.weeklyTrend,
  });
}

class ChartData {
  final String label;
  final double minutes;
  final bool isToday;

  ChartData({required this.label, required this.minutes, this.isToday = false});
}
