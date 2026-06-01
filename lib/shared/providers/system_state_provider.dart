import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/system_repository.dart';

class SystemStateProvider extends BaseProvider {
  final SystemRepository _systemRepo = locator<SystemRepository>();

  String _dailyQuote = "静心修行，找回自我...";

  String get dailyQuote => _dailyQuote;

  Future<void> fetchDailyQuote({bool isSilent = true}) async {
    if (!isSilent) setLoading(true);
    clearError();

    try {
      final result = await _systemRepo.fetchDailyQuote();

      if (result.status && result.data != null) {
        _dailyQuote = result.data!;
        notifyListeners();
      } else {
        if (!isSilent) setError(result.message);
      }
    } catch (e) {
      if (!isSilent) setError("获取每日金句失败");
    } finally {
      if (!isSilent) setLoading(false);
    }
  }
}
