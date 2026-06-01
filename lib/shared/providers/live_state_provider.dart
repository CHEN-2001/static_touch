import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';

class LiveStateProvider extends BaseProvider {
  final LiveRepository _liveRepo = locator<LiveRepository>();

  // --- 全局共享的直播状态 ---
  String? _currentLiveId; // 当前所在的直播间ID (null 表示不在任何直播间)
  bool _isAnchor = false; // 当前身份是否为主播
  String? _currentStreamUrl; // 观众正在拉流的地址
  String? _currentRtmpUrl; // 主播正在推流的地址

  // --- Getters ---
  String? get currentLiveId => _currentLiveId;
  bool get isAnchor => _isAnchor;
  String? get currentStreamUrl => _currentStreamUrl;
  String? get currentRtmpUrl => _currentRtmpUrl;
  bool get isInLiveRoom => _currentLiveId != null; // 全局判断是否在看播/开播中

  /// 🚀 当进入直播间时调用（无论是主播开播成功，还是观众进房成功）
  /// 用来激活全局的直播状态，方便全 App（如悬浮窗播放器）共享
  void activateLiveState({required String liveId, required bool isAnchor, String? streamUrl, String? rtmpUrl}) {
    _currentLiveId = liveId;
    _isAnchor = isAnchor;
    _currentStreamUrl = streamUrl;
    _currentRtmpUrl = rtmpUrl;
    notifyListeners();
  }

  /// 🚀 全局退出或结束直播
  /// 如果是主播，会自动触发后端 /live/end/{id} 接口进行关播
  /// 如果是观众，会清理状态并安全断开拉流
  Future<bool> leaveOrEndLive() async {
    if (_currentLiveId == null) return true;

    setLoading(true);
    clearError();

    try {
      if (_isAnchor) {
        // 主播身份：退出时必须强制调用后端接口关闭直播间
        final result = await _liveRepo.endLive(_currentLiveId!);
        if (!result.status) {
          setError(result.message);
          return false;
        }
      }

      // 观众身份或主播关播接口成功后，清理本地所有全局流媒体变量
      _clearLocalState();
      return true;
    } catch (e) {
      setError("退出直播异常，请重试");
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// 异常被动断开、或者被服务端踢出时，用于静默强制清理本地状态
  void forceClearState() {
    _clearLocalState();
  }

  void _clearLocalState() {
    _currentLiveId = null;
    _isAnchor = false;
    _currentStreamUrl = null;
    _currentRtmpUrl = null;
    notifyListeners();
  }
}
