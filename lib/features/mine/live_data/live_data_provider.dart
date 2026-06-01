import 'package:flutter/material.dart'; // 🚀 新增引入
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 🚀 新增引入提示框

class LiveDataProvider extends BaseProvider {
  final LiveRepository _repo = locator<LiveRepository>();

  LiveDataModel? _stats;
  LiveDataModel? get stats => _stats;

  List<dynamic> _upcomingLives = [];
  List<dynamic> get upcomingLives => _upcomingLives;

  Future<void> fetchStats() async {
    setLoading(true);
    clearError();

    final results = await Future.wait([_repo.fetchLivePage(), _repo.fetchTodayLiveList()]);

    final pageRes = results[0];
    final todayRes = results[1];

    if (pageRes.status && pageRes.data != null) {
      if (pageRes.data is Map<String, dynamic>) {
        _stats = LiveDataModel.fromJson(pageRes.data);
      }
    } else {
      setError(pageRes.message);
    }

    if (todayRes.status && todayRes.data != null && todayRes.data is List) {
      final List rawList = todayRes.data as List;
      _upcomingLives = rawList.where((item) {
        final stateCode = item['status'] ?? item['statusCode'];
        return stateCode == 0;
      }).toList();
    }

    setLoading(false);
  }

  // 🚀 新增：取消预告逻辑
  Future<void> cancelSchedule(BuildContext context, String liveId) async {
    setLoading(true);
    final result = await _repo.cancelSchedule(liveId);

    if (result.status) {
      if (context.mounted) {
        context.showAppToast(message: '已取消直播预告', type: AppToastType.success);
      }
      await fetchStats(); // 取消成功后静默刷新列表
    } else {
      setError(result.message);
    }
    setLoading(false);
  }
}
