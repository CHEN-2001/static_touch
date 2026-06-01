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

  // 🚀 新增：标准 fromJson 解析
  factory LiveDataModel.fromJson(Map<String, dynamic> json) {
    return LiveDataModel(
      totalHours: json['totalHours']?.toString() ?? '0',
      totalCount: int.tryParse(json['totalCount']?.toString() ?? '0') ?? 0,
      trendRate: json['trendRate']?.toString() ?? '0%',
      trendData:
          (json['trendData'] as List<dynamic>?)?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>)).toList() ??
          [],
      // 兼容后端返回 history 或 records 字段
      history:
          (json['history'] as List<dynamic>? ?? json['records'] as List<dynamic>?)
              ?.map((e) => LiveHistoryRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TrendPoint {
  final String label; // x轴标签，如 "02-26"
  final double value; // y轴数值

  TrendPoint(this.label, this.value);

  // 🚀 新增：解析点数据
  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(json['label']?.toString() ?? '', double.tryParse(json['value']?.toString() ?? '0') ?? 0.0);
  }
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

  factory LiveHistoryRecord.fromJson(Map<String, dynamic> json) {
    return LiveHistoryRecord(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '未命名直播',
      timeLabel: json['timeLabel']?.toString() ?? '',
      fullDate: json['fullDate']?.toString() ?? '',
      durationMinutes: int.tryParse(json['durationMinutes']?.toString() ?? '0') ?? 0,
      viewers:
          int.tryParse(json['viewers']?.toString() ?? '0') ?? int.tryParse(json['onlineCount']?.toString() ?? '0') ?? 0,
      comments: int.tryParse(json['comments']?.toString() ?? '0') ?? 0,
      checkIns: int.tryParse(json['checkIns']?.toString() ?? '0') ?? 0,
    );
  }
}
