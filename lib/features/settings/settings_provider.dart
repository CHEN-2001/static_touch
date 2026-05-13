import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/core/utils/token_manager.dart';

class SettingsProvider extends BaseProvider {
  // 模拟的本地配置状态
  bool newMsgPush = true;
  bool liveStartRemind = true;
  bool autoCheckIn = false;
  bool backgroundPlay = true;

  void toggleMsgPush(bool val) {
    newMsgPush = val;
    notifyListeners();
  }

  void toggleLiveRemind(bool val) {
    liveStartRemind = val;
    notifyListeners();
  }

  void toggleAutoCheck(bool val) {
    autoCheckIn = val;
    notifyListeners();
  }

  void toggleBgPlay(bool val) {
    backgroundPlay = val;
    notifyListeners();
  }

  // 🚀 将退出登录的业务逻辑收拢到 Provider 中
  Future<bool> logout() async {
    setLoading(true);
    // 模拟告诉后端退出登录的请求延迟
    await Future.delayed(const Duration(milliseconds: 600));

    // 清除本地 Token
    await TokenManager.clearToken();

    setLoading(false);
    return true;
  }
}
