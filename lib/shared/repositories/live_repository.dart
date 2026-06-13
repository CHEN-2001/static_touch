import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class LiveRepository {
  final HttpClient _client;
  LiveRepository(this._client);

  // ================= 主播端接口 =================

  // 预发布直播间
  Future<ResultEntity> scheduleLive({required String title, String description = '', String? expectedStartTime}) async {
    final data = {'title': title, 'description': description, 'expectedStartTime': expectedStartTime};
    return await _client.post(ApiEndpoints.liveSchedule, data: data);
  }

  // 正式开播 (支持直接开播，也支持带着 scheduledLiveId 启动预发布)
  Future<ResultEntity> startLive({
    String? title,
    String? description,
    String? coverUrl,
    String? scheduledLiveId,
  }) async {
    final data = {
      if (title != null && title.isNotEmpty) 'title': title,
      if (coverUrl != null && coverUrl.isNotEmpty) 'coverUrl': coverUrl,
      if (scheduledLiveId != null && scheduledLiveId.isNotEmpty) 'scheduledLiveId': scheduledLiveId,
    };
    return await _client.post(ApiEndpoints.liveStart, data: data);
  }

  // 取消预发布的房间
  Future<ResultEntity> cancelSchedule(String liveId) async {
    return await _client.post(ApiEndpoints.liveCancel(liveId));
  }

  // 结束直播
  Future<ResultEntity> endLive(String liveId) async {
    return await _client.post('${ApiEndpoints.liveBase}/$liveId/end');
  }

  // 检查是否预直播是否发布
  Future<ResultEntity> checkScheduledLive() async {
    return await _client.get(ApiEndpoints.liveScheduleCheck);
  }

  /// 获取待开播列表
  Future<ResultEntity> fetchUpcomingLives() async {
    return await _client.get(ApiEndpoints.liveUpcoming);
  }

  /// 获取历史直播列表（分页查库）
  Future<ResultEntity> fetchLiveHistory({int pageNum = 1, int pageSize = 10}) async {
    return await _client.get(ApiEndpoints.liveHistory, queryParameters: {'pageNum': pageNum, 'pageSize': pageSize});
  }

  // 心跳保活 (App端定时器每隔几秒静默调用)
  Future<ResultEntity> heartbeat(String liveId) async {
    return await _client.post('${ApiEndpoints.liveBase}/$liveId/heartbeat');
  }

  // ================= 观众端接口 =================

  // 获取今日直播列表
  Future<ResultEntity> fetchTodayLiveList() async {
    return await _client.get(ApiEndpoints.liveToday);
  }

  // 获取分页大厅列表
  Future<ResultEntity> fetchLivePage({int pageNum = 1, int pageSize = 10}) async {
    return await _client.get(ApiEndpoints.livePage, queryParameters: {'pageNum': pageNum, 'pageSize': pageSize});
  }

  // 点击进入直播间 (实时获取拉流地址)
  Future<ResultEntity> enterLiveRoom(String liveId) async {
    return await _client.get(ApiEndpoints.liveEnterRoom(liveId));
  }
}
