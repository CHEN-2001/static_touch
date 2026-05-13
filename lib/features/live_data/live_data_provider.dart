import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart'; // 🚀 引入全局 Model

class LiveDataProvider extends BaseProvider {
  final LiveRepository _repo = locator<LiveRepository>();

  LiveDataModel? _stats;
  LiveDataModel? get stats => _stats;

  Future<void> fetchStats() async {
    setLoading(true);
    clearError();

    final result = await _repo.fetchLiveStats();

    if (result.status && result.data != null) {
      _stats = result.data;
    } else {
      setError(result.message); // 利用 BaseProvider 自动弹错
    }

    setLoading(false);
  }
}
