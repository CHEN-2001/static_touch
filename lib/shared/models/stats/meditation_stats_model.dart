import 'package:flutter/foundation.dart'; // 引入 foundation 以使用 listEquals 进行列表深度比对

/// 冥想每周趋势数据模型
class WeeklyTrendModel {
  final String date;
  final int minutes;

  WeeklyTrendModel({this.date = '', this.minutes = 0});

  factory WeeklyTrendModel.empty() => WeeklyTrendModel();

  factory WeeklyTrendModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return WeeklyTrendModel.empty();

    return WeeklyTrendModel(
      date: json['date']?.toString() ?? '',
      minutes: int.tryParse(json['minutes']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'minutes': minutes};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeeklyTrendModel && other.date == date && other.minutes == minutes;
  }

  @override
  int get hashCode => date.hashCode ^ minutes.hashCode;
}

/// 冥想统计总数据模型
class MeditationStatsModel {
  final int totalDays;
  final int streakDays;
  final int totalMinutes;
  final int thisWeekMinutes;
  final List<WeeklyTrendModel> weeklyTrend;

  MeditationStatsModel({
    this.totalDays = 0,
    this.streakDays = 0,
    this.totalMinutes = 0,
    this.thisWeekMinutes = 0,
    this.weeklyTrend = const [],
  });

  factory MeditationStatsModel.empty() => MeditationStatsModel();

  factory MeditationStatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MeditationStatsModel.empty();

    List<WeeklyTrendModel> parseWeeklyTrend(dynamic value) {
      if (value is List) {
        return value.map((e) => WeeklyTrendModel.fromJson(e as Map<String, dynamic>?)).toList();
      }
      return [];
    }

    return MeditationStatsModel(
      totalDays: int.tryParse(json['totalDays']?.toString() ?? '0') ?? 0,
      streakDays: int.tryParse(json['streakDays']?.toString() ?? '0') ?? 0,
      totalMinutes: int.tryParse(json['totalMinutes']?.toString() ?? '0') ?? 0,
      thisWeekMinutes: int.tryParse(json['thisWeekMinutes']?.toString() ?? '0') ?? 0,
      weeklyTrend: parseWeeklyTrend(json['weeklyTrend']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDays': totalDays,
      'streakDays': streakDays,
      'totalMinutes': totalMinutes,
      'thisWeekMinutes': thisWeekMinutes,
      'weeklyTrend': weeklyTrend.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeditationStatsModel &&
        other.totalDays == totalDays &&
        other.streakDays == streakDays &&
        other.totalMinutes == totalMinutes &&
        other.thisWeekMinutes == thisWeekMinutes &&
        listEquals(other.weeklyTrend, weeklyTrend);
  }

  @override
  int get hashCode {
    return totalDays.hashCode ^
        streakDays.hashCode ^
        totalMinutes.hashCode ^
        thisWeekMinutes.hashCode ^
        weeklyTrend.hashCode;
  }
}
