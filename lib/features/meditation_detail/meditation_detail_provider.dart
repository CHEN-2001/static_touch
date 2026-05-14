import 'package:static_touch/shared/providers/base_provider.dart'; // 🚀 引入基类
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/models/live/live_detailed_model.dart';
import 'package:static_touch/features/meditation_detail/live_detailed_service.dart';

class MeditationDetailProvider extends BaseProvider {
  // 🚀 继承基类
  final MeditationService _service = MeditationService();

  MeditationScheduleModel? _detail;
  MeditationScheduleModel? get detail => _detail;

  bool _isReminded = false;
  bool get isReminded => _isReminded;

  // 加载详情
  Future<void> loadDetail(LiveItemModel item) async {
    setLoading(true); // 🚀 使用基类的加载状态
    _detail = await _service.fetchDetailFromApi(item);
    setLoading(false); // 🚀 即使这里用户突然退出页面，也会被 BaseProvider 安全拦截！
  }

  // 切换提醒
  Future<void> toggleRemind(int itemId) async {
    final newValue = !_isReminded;
    await _service.setReminder(itemId, newValue);
    _isReminded = newValue;
    notifyListeners();
  }
}
