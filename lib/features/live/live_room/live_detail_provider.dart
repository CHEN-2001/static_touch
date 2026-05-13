import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/base_provider.dart';

class LiveDetailProvider extends BaseProvider {
  String? _pullUrl;
  String? get pullUrl => _pullUrl;

  final List<String> _danmuList = ["欢迎来到静心直播间", "主播的声音让人很放松~"];
  List<String> get danmuList => _danmuList;

  Future<void> enterRoom(String roomId) async {
    setLoading(true);
    clearError();

    final repo = locator<LiveRepository>();
    final result = await repo.enterLiveRoom(roomId);

    setLoading(false);

    if (result.status) {
      _pullUrl = result.data;
    } else {
      setError(result.message);
    }
  }

  void sendDanmu(String text) {
    if (text.trim().isNotEmpty) {
      _danmuList.add(text);
      notifyListeners();
    }
  }
}
