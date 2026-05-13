class LiveDataModel {
  final String totalHours;
  final int totalCount;
  final String trendRate; // 本周增长率，如 "+15%"
  final List<TrendPoint> trendData; // 图表数据点
  final List<LiveHistoryRecord> history;

  LiveDataModel({
    required this.totalHours,
    required this.totalCount,
    required this.trendRate,
    required this.trendData,
    required this.history,
  });
}

class TrendPoint {
  final String label; // x轴标签，如 "02-26"
  final double value; // y轴数值
  TrendPoint(this.label, this.value);
}

class LiveHistoryRecord {
  final String id;
  final String title;
  final String timeLabel;
  final String fullDate; // 弹窗显示的完整日期
  final int durationMinutes;
  final int viewers; // 观看人数
  final int comments; // 评论互动
  final int checkIns; // 打卡人数

  LiveHistoryRecord({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.fullDate,
    required this.durationMinutes,
    required this.viewers,
    required this.comments,
    required this.checkIns,
  });
}
