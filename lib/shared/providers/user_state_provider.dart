import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/models/user/user_model.dart';
import 'package:static_touch/core/utils/time_greeting_utils.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';

class UserStateProvider extends BaseProvider {
  final UserRepository _userRepo = locator<UserRepository>();

  UserModel _user = UserModel.empty();
  String _dailyQuote = "";
  int _totalDuration = 0;

  UserModel get user => _user;
  String get dailyQuote => _dailyQuote;
  int get totalDuration => _totalDuration;

  String get greeting => TimeGreetingUtils.getGreeting();

  // 🚀 核心优化：增加 isSilent 参数。如果是静默刷新，就不触发骨架屏
  Future<void> initData({bool isSilent = false}) async {
    if (!isSilent) setLoading(true); // 只有非静默状态（首次进入）才触发加载动画/骨架屏
    clearError();

    try {
      final result = await _userRepo.fetchUserInfo();

      if (result.status && result.data != null) {
        _user = result.data!;
        _dailyQuote = _user.dailyQuote;
        _totalDuration = _user.totalDuration;
        // 🚀 拿到新数据后，通知 UI 局部更新（静默替换旧数据）
        notifyListeners();
      } else {
        if (!isSilent) setError(result.message);
      }
    } catch (e) {
      if (!isSilent) setError("获取用户信息失败");
    } finally {
      if (!isSilent) setLoading(false);
    }
  }
}
