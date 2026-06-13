import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class LiveDataProvider extends BaseProvider {
  final LiveRepository _repo = locator<LiveRepository>();

  LiveDataModel? _stats;
  LiveDataModel? get stats => _stats;

  List<dynamic> _upcomingLives = [];
  List<dynamic> get upcomingLives => _upcomingLives;

  // 🚀 分页支持
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// 拉取页面数据 (isRefresh=true 为下拉刷新，否则为上拉加载下一页)
  Future<void> fetchStats({bool isRefresh = true}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      setLoading(true);
    } else {
      if (!_hasMore) return; // 没有更多数据则直接返回
      _currentPage++;
    }

    clearError();

    // 🚀 核心替换：直接调用我们新增的两个专属接口！
    final results = await Future.wait([
      _repo.fetchLiveHistory(pageNum: _currentPage, pageSize: 10),
      _repo.fetchUpcomingLives(),
    ]);

    final historyRes = results[0];
    final upcomingRes = results[1];

    // 1. 处理历史记录
    if (historyRes.status && historyRes.data != null) {
      if (historyRes.data is Map<String, dynamic>) {
        final data = Map<String, dynamic>.from(historyRes.data as Map);

        // 【巧妙衔接】：后端 Page 对象返回的是 total，我们临时塞给 totalCount 喂给卡片展示
        if (data['total'] != null) {
          data['totalCount'] = data['total'];
        }

        if (isRefresh) {
          _stats = LiveDataModel.fromJson(data);
        } else {
          // 如果是加载更多，只追加 history 数组，不覆盖顶层统计
          final newData = LiveDataModel.fromJson(data);
          _stats?.history.addAll(newData.history);
        }

        // 根据 Mybatis-Plus 的返回结果判断是否有下一页
        final current = data['current'] as int? ?? 1;
        final pages = data['pages'] as int? ?? 1;
        _hasMore = current < pages;
      }
    } else {
      setError(historyRes.message);
    }

    // 2. 处理待开播列表（后端已经纯净输出了，直接赋值即可，无需任何过滤！）
    if (isRefresh && upcomingRes.status && upcomingRes.data != null) {
      if (upcomingRes.data is List) {
        _upcomingLives = upcomingRes.data as List<dynamic>;
      }
    }

    if (isRefresh) setLoading(false);
    notifyListeners(); // 别忘了通知 UI 刷新
  }

  // 取消预告逻辑
  Future<void> cancelSchedule(BuildContext context, String liveId) async {
    setLoading(true);
    final result = await _repo.cancelSchedule(liveId);

    if (result.status) {
      if (context.mounted) {
        context.showAppToast(message: '已取消直播预告', type: AppToastType.success);
      }
      // 成功后重新刷一次最新列表
      await fetchStats(isRefresh: true);
    } else {
      setError(result.message);
    }
    setLoading(false);
  }
}
