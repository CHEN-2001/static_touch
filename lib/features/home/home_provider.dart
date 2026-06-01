import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';

class HomeProvider extends BaseProvider {
  final LiveRepository _liveRepo = locator<LiveRepository>();

  // 首页时刻表数据源
  List<LiveItemModel> _scheduleItems = [];
  List<LiveItemModel> get scheduleItems => _scheduleItems;

  /// 获取首页今日时刻表
  Future<void> fetchTodaySchedule({bool isSilent = false}) async {
    if (!isSilent) setLoading(true);
    clearError();

    try {
      final result = await _liveRepo.fetchTodayLiveList();
      if (result.status && result.data != null) {
        List listData = [];
        if (result.data is List) {
          listData = result.data as List;
        } else if (result.data is Map) {
          listData = result.data['list'] ?? [];
        }
        _scheduleItems = listData.map((e) => LiveItemModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        if (!isSilent) setError(result.message);
      }
    } catch (e) {
      if (!isSilent) setError("获取首页时刻表失败，请检查网络");
    } finally {
      if (!isSilent) setLoading(false);
    }
  }
}
