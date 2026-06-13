import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/models/live/live_prepare_model.dart';

class LiveProvider extends BaseProvider {
  final LiveRepository _liveRepo = locator<LiveRepository>();
  // 列表数据源
  List<LiveItemModel> _scheduleItems = [];
  List<LiveItemModel> get scheduleItems => _scheduleItems;

  // 选中的下标
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  // tags列表
  final List<String> tabs = ['全部', '直播中', '即将开始', '已结束'];

  // 选中下标的方法
  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // 获取直播列表
  Future<void> fetchTodaySchedule({bool isSilent = false}) async {
    if (!isSilent) setLoading(true);
    clearError();
    try {
      final result = await _liveRepo.fetchLivePage();
      if (result.status && result.data != null) {
        final List listData = result.data['records'] ?? [];
        _scheduleItems = listData.map((e) => LiveItemModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        if (!isSilent) setError(result.message);
      }
    } catch (e) {
      if (!isSilent) setError("获取直播列表失败，请检查网络");
    } finally {
      if (!isSilent) setLoading(false);
    }
  }

  Future<LivePrepareModel?> checkScheduledLive() async {
    try {
      final result = await _liveRepo.checkScheduledLive();
      if (result.status && result.data != null) {
        return LivePrepareModel.fromJson(result.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
