import 'dart:async';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart';

class LiveRepository {
  final HttpClient _client;
  LiveRepository(this._client);

  static const bool isMock = true;

  // 获取直播列表
  Future<List<LiveItemModel>> fetchLiveListFromApi() async {
    if (!isMock) {
      final result = await _client.get('/live/list');
      if (result.status && result.data is List) {
        return (result.data as List)
            .map((e) => LiveItemModel.fromJson(e))
            .toList();
      }
      return [];
    }
    await Future.delayed(const Duration(seconds: 1));
    return [
      LiveItemModel(
        id: '1',
        title: '深度睡眠环境音',
        status: LiveStatus.ended,
        coverUrl: '',
        anchorName: '导师A',
        anchorAvatar: '',
        viewerCount: 120,
        timeDisplay: '昨日 20:00',
      ),
      LiveItemModel(
        id: '2',
        title: '晨间正念冥想直播',
        status: LiveStatus.live,
        coverUrl: '',
        anchorName: '不二法门',
        anchorAvatar: '',
        viewerCount: 356,
        timeDisplay: '09:00 - 10:00',
      ),
      LiveItemModel(
        id: '3',
        title: '晚间助眠修行预告',
        status: LiveStatus.preparing,
        coverUrl: '',
        anchorName: '导师B',
        anchorAvatar: '',
        viewerCount: 0,
        timeDisplay: '22:00 - 23:00',
      ),
    ];
  }

  // 监听直播状态
  Stream<LiveItemModel> listenLiveUpdates() async* {}

  // 主播创建直播间
  Future<ResultEntity<String>> createLiveRoom(String title) async {
    await Future.delayed(const Duration(seconds: 1));
    return ResultEntity(status: true, message: '创建成功', data: 'rtmp://test');
  }

  // 观众进入直播间
  Future<ResultEntity<String>> enterLiveRoom(String roomId) async {
    await Future.delayed(const Duration(seconds: 1));
    return ResultEntity(status: true, message: '进入成功', data: 'http://test.flv');
  }

  // 🚀 主播获取直播数据统计 (更新了数据结构以支持图表和弹窗)
  Future<ResultEntity<LiveDataModel>> fetchLiveStats() async {
    if (!isMock) {
      // return await _client.get('/live/stats');
    }
    await Future.delayed(const Duration(milliseconds: 600));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: LiveDataModel(
        totalHours: "1,220",
        totalCount: 365,
        trendRate: "本周 +15%",
        trendData: [
          TrendPoint("02-26", 20),
          TrendPoint("", 40),
          TrendPoint("03-01", 60),
          TrendPoint("", 45),
          TrendPoint("", 50),
          TrendPoint("今日", 30),
        ],
        history: [
          LiveHistoryRecord(
            id: "101",
            title: "直播标题二",
            timeLabel: "昨天 8:00",
            fullDate: "2026-03-04",
            durationMinutes: 32,
            viewers: 800,
            comments: 120,
            checkIns: 90,
          ),
          LiveHistoryRecord(
            id: "102",
            title: "直播标题一",
            timeLabel: "3月2日",
            fullDate: "2026-03-02",
            durationMinutes: 60,
            viewers: 1000,
            comments: 156,
            checkIns: 100,
          ),
        ],
      ),
    );
  }
}
