import 'dart:async';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart';

class LiveRepository {
  final HttpClient _client;
  LiveRepository(this._client);

  // 🚀 核心架构设计：一键切换真实后台与本地模拟
  static const bool isMock = true;

  // ================= 1. 获取直播列表 =================
  Future<List<LiveItemModel>> fetchLiveListFromApi() async {
    if (!isMock) {
      final result = await _client.get('/live/list');
      if (result.status && result.data is List) {
        return (result.data as List).map((e) => LiveItemModel.fromJson(e)).toList();
      }
      return [];
    }

    // --- 模拟数据 ---
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

  // ================= 2. 监听直播状态变更 =================
  Stream<LiveItemModel> listenLiveUpdates() async* {
    if (!isMock) {
      // 真实环境下，这里未来对接 WebSocket 监听
      // yield* WebSocketClient.liveUpdates();
      return;
    }

    // --- 模拟数据 ---
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      yield LiveItemModel(
        id: '3',
        title: '晚间助眠修行预告',
        status: LiveStatus.live,
        coverUrl: '',
        anchorName: '导师B',
        anchorAvatar: '',
        viewerCount: 50,
        timeDisplay: '22:00 - 23:00',
      );
    }
  }

  // ================= 3. 主播：获取推流地址 =================
  Future<ResultEntity<String>> createLiveRoom(String title) async {
    if (!isMock) {
      final res = await _client.post('/live/create', data: {'title': title});
      return ResultEntity(status: res.status, message: res.message, data: res.data?['pushUrl']);
    }

    // --- 模拟数据 ---
    await Future.delayed(const Duration(seconds: 1));
    return ResultEntity(
      status: true,
      message: '创建成功',
      data: 'rtmp://push.statictouch.com/live/room_${DateTime.now().millisecondsSinceEpoch}?sign=xyz',
    );
  }

  // ================= 4. 观众：获取拉流地址 =================
  Future<ResultEntity<String>> enterLiveRoom(String roomId) async {
    if (!isMock) {
      final res = await _client.get('/live/playUrl', queryParameters: {'roomId': roomId});
      return ResultEntity(status: res.status, message: res.message, data: res.data?['pullUrl']);
    }

    // --- 模拟数据 ---
    await Future.delayed(const Duration(seconds: 1));
    return ResultEntity(status: true, message: '进入成功', data: 'https://pull.statictouch.com/live/room_$roomId.flv');
  }

  // ================= 5. 主播：获取直播数据统计 =================
  Future<ResultEntity<LiveDataModel>> fetchLiveStats() async {
    if (!isMock) {
      final result = await _client.get('/live/stats');
      if (result.status && result.data != null) {
        return ResultEntity(status: true, message: '获取成功', data: LiveDataModel.fromJson(result.data));
      }
      return ResultEntity.error(result.message);
    }

    // --- 模拟数据 ---
    await Future.delayed(const Duration(milliseconds: 600));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: LiveDataModel(
        totalHours: "1,220",
        totalCount: 365,
        history: [
          LiveHistoryRecord(id: "101", title: "晚间助眠修行回顾", timeLabel: "昨天 22:00", durationMinutes: 45),
          LiveHistoryRecord(id: "102", title: "晨间正念冥想", timeLabel: "3月2日 09:00", durationMinutes: 60),
        ],
      ),
    );
  }
}
