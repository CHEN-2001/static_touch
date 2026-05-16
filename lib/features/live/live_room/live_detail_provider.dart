import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart'; // 🚀 引入播放器
import 'package:media_kit_video/media_kit_video.dart'; // 🚀 引入视频控制器
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class LiveDetailProvider extends BaseProvider {
  String? _pullUrl;
  String? get pullUrl => _pullUrl;

  // 🚀 1. 声明播放器和控制器
  late final Player player = Player();
  late final VideoController videoController = VideoController(player);

  final List<String> _danmuList = ["欢迎来到静心直播间", "主播的声音让人很放松~"];
  List<String> get danmuList => _danmuList;

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

    if (result.status && result.data != null) {
      _pullUrl = result.data;
      debugPrint("🚀 [播放器] 准备拉取的地址是: $_pullUrl");

      // 🚀 重点：监听底层的各种状态，打印到控制台
      player.stream.error.listen((error) {
        debugPrint('❌ [播放器报错] 发生严重错误: $error');
      });

      player.stream.buffering.listen((isBuffering) {
        debugPrint('⏳ [播放器缓冲] 正在缓冲数据: $isBuffering');
      });

      player.stream.width.listen((width) {
        debugPrint('✅ [播放器画面] 成功解析到视频！宽度: $width');
      });

      // 开启播放
      await player.open(Media(_pullUrl!), play: true);
    } else {
      setError(result.message);
    }
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    // 🚀 控制底层播放器暂停/继续
    player.playOrPause();
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    // 🚀 控制底层播放器音量 (0静音，100最大)
    player.setVolume(_isMuted ? 0.0 : 100.0);
    notifyListeners();
  }

  void toggleAudioOnly(BuildContext context) {
    _isAudioOnly = !_isAudioOnly;
    notifyListeners();
    context.showAppToast(message: _isAudioOnly ? "已關閉視頻，進入純音頻模式" : "已恢復視頻畫面", type: AppToastType.info);
  }

  // ... (保留你原来的 sendDanmu, doCheckIn 等方法) ...
  void sendDanmu(String text) {
    if (text.trim().isNotEmpty) {
      _danmuList.add(text);
      notifyListeners();
    }
  }

  void doCheckIn(BuildContext context) {
    if (_hasCheckedIn) {
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

  // 🚀 3. 页面销毁时，释放播放器内存
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
