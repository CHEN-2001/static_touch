import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class LiveDetailProvider extends BaseProvider {
  String? _pullUrl;
  String? get pullUrl => _pullUrl;

  final List<String> _danmuList = ["欢迎来到静心直播间", "主播的声音让人很放松~"];
  List<String> get danmuList => _danmuList;

  // ================= PRD 文档规定的核心状态 =================
  bool _isPlaying = true;
  bool get isPlaying => _isPlaying;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isAudioOnly = false;
  bool get isAudioOnly => _isAudioOnly;

  bool _hasCheckedIn = false;
  bool get hasCheckedIn => _hasCheckedIn;

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  String? _currentWhiteNoise;
  String? get currentWhiteNoise => _currentWhiteNoise;

  double _whiteNoiseVolume = 0.5;
  double get whiteNoiseVolume => _whiteNoiseVolume;

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

  // ================= PRD 交互逻辑实现 =================
  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleAudioOnly(BuildContext context) {
    _isAudioOnly = !_isAudioOnly;
    notifyListeners();
    context.showAppToast(message: _isAudioOnly ? "已關閉視頻，進入純音頻模式" : "已恢復視頻畫面", type: AppToastType.info);
  }

  void doCheckIn(BuildContext context) {
    if (_hasCheckedIn) {
      // 严格落实 PRD: 重复点提示已打卡
      context.showAppToast(message: "今日已打卡，請繼續保持專注", type: AppToastType.info);
    } else {
      _hasCheckedIn = true;
      notifyListeners();
      context.showAppToast(message: "靜心打卡成功！", type: AppToastType.success);
    }
  }

  void toggleFavorite(BuildContext context) {
    _isFavorited = !_isFavorited;
    notifyListeners();
    context.showAppToast(message: _isFavorited ? "已收藏" : "已取消收藏", type: AppToastType.success);
  }

  void toggleWhiteNoise(String noise) {
    _currentWhiteNoise = (_currentWhiteNoise == noise) ? null : noise;
    notifyListeners();
  }

  void setWhiteNoiseVolume(double vol) {
    _whiteNoiseVolume = vol;
    notifyListeners();
  }
}
