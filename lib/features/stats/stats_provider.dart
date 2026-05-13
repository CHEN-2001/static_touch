import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/stats_repository.dart';
import 'package:static_touch/shared/models/stats/stats_model.dart';

class StatsProvider extends BaseProvider {
  final StatsRepository _repo = locator<StatsRepository>();

  StatsModel? _stats;
  StatsModel? get stats => _stats;

  Future<void> fetchStats() async {
    setLoading(true);
    clearError();

    final result = await _repo.fetchStats();

    if (result.status && result.data != null) {
      _stats = result.data;
    } else {
      setError(result.message);
    }

    setLoading(false);
  }
}
