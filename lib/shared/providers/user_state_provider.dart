import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/models/user/user_model.dart';
import 'package:static_touch/shared/models/stats/meditation_stats_model.dart';
import 'package:static_touch/core/utils/time_greeting_utils.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';

class UserStateProvider extends BaseProvider {
  final UserRepository _userRepo = locator<UserRepository>();

  UserModel _user = UserModel.empty();
  String _dailyQuote = "";

  MeditationStatsModel _stats = MeditationStatsModel.empty();

  UserModel get user => _user;
  String get dailyQuote => _dailyQuote;

  MeditationStatsModel? get stats => _stats;

  int get totalDuration => _stats.totalMinutes;

  String get greeting => TimeGreetingUtils.getGreeting();

  Future<void> initData({bool isSilent = false}) async {
    if (!isSilent) setLoading(true);
    clearError();
    try {
      final results = await Future.wait([_userRepo.fetchUserInfo(), _userRepo.fetchUserStats()]);
      final userResult = results[0] as ResultEntity<UserModel>;
      final statsResult = results[1] as ResultEntity<MeditationStatsModel>;
      if (userResult.status && userResult.data != null) {
        _user = userResult.data!;
        _dailyQuote = _user.dailyQuote;
      } else {
        if (!isSilent) setError(userResult.message);
      }
      if (statsResult.status && statsResult.data != null) {
        _stats = statsResult.data!;
      } else {
        _stats = MeditationStatsModel();
      }
      notifyListeners();
    } catch (e) {
      if (!isSilent) setError("获取用户聚合数据失败");
    } finally {
      if (!isSilent) setLoading(false);
    }
  }
}
