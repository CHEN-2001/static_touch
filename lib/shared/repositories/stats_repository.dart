import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/stats/stats_model.dart';

class StatsRepository {
  final HttpClient _client;
  StatsRepository(this._client);

  static const bool isMock = true;

  Future<ResultEntity<StatsModel>> fetchStats() async {
    if (!isMock) {
      // 真实 API 请求预留
      // final res = await _client.get('/stats/summary');
    }

    // --- 模拟数据 ---
    await Future.delayed(const Duration(milliseconds: 600));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: StatsModel(
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
          ChartData(label: '今日', minutes: 65, isToday: true),
        ],
      ),
    );
  }
}
