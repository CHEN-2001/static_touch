import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/network/api_endpoints.dart';
import 'package:static_touch/shared/models/live/live_chat_message_model.dart';
import 'package:go_router/go_router.dart';

class LiveDetailProvider extends BaseProvider {
  String? _pullUrl;
  String? get pullUrl => _pullUrl;

  late final Player player = Player();
  late final VideoController videoController = VideoController(player);

  // 讨论区数据改为模型列表
  final List<LiveChatMessageModel> _danmuList = [];
  List<LiveChatMessageModel> get danmuList => _danmuList;

  // 在线人数记录
  int _onlineCount = 0;
  int get onlineCount => _onlineCount;

  // WebSocket 频道
  WebSocketChannel? _wsChannel;

  // 保留原有的业务状态
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
      if (result.data is Map) {
        _pullUrl = result.data['pullUrl'];
      } else {
        _pullUrl = result.data.toString();
      }

      debugPrint("🚀 [播放器] 准备拉取的地址是: $_pullUrl");

      player.stream.error.listen((error) => debugPrint('❌ [播放器报错] 发生严重错误: $error'));
      player.stream.buffering.listen((isBuffering) => debugPrint('⏳ [播放器缓冲] 正在缓冲数据: $isBuffering'));
      player.stream.width.listen((width) => debugPrint('✅ [播放器画面] 成功解析到视频！宽度: $width'));

      if (_pullUrl != null && _pullUrl!.isNotEmpty) {
        await player.open(Media(_pullUrl!), play: true);
      }

      // 视频准备完毕后，初始化 WebSocket
      await _initWebSocket(roomId);
    } else {
      setError(result.message);
    }
  }

  // 使用你真实的配置获取 Token 和 WebSocket URL
  Future<void> _initWebSocket(String roomId) async {
    try {
      // 1. 调用真实的 getAccessToken
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) return;

      // 2. 调用真实的 wsBaseUrl
      final wsUrl = Uri.parse('${ApiEndpoints.wsBaseUrl}/ws/live/chat/$roomId?token=$token');

      _wsChannel = WebSocketChannel.connect(wsUrl);

      _wsChannel!.stream.listen((message) {
        final data = jsonDecode(message as String);
        final msg = LiveChatMessageModel.fromJson(data);

        // 拦截关播指令
        if (msg.type == 'COMMAND' && msg.content == 'CLOSE_ROOM') {
          _handleCloseCommand();
          return;
        }

        // 拦截系统人数刷新
        if (msg.type == 'SYSTEM' && int.tryParse(msg.content) != null) {
          _onlineCount = int.parse(msg.content);
          notifyListeners();
          return;
        }

        // 常规消息防内存溢出保护
        if (_danmuList.length > 200) {
          _danmuList.removeAt(0);
        }

        _danmuList.add(msg);
        notifyListeners();
      });
    } catch (e) {
      debugPrint('❌ [WebSocket] 初始化异常: $e');
    }
  }

  void _handleCloseCommand() {
    player.stop();
    _wsChannel?.sink.close();
    final context = NavService.rootNavigatorKey.currentContext;
    if (context != null) {
      context.showAppToast(message: '直播已结束', type: AppToastType.success);
      if (context.canPop()) {
        context.pop();
      } else {
        NavService.go('/main');
      }
    } else {
      NavService.go('/main');
    }
  }

  void sendDanmu(String text) {
    if (text.trim().isNotEmpty && _wsChannel != null) {
      _wsChannel!.sink.add(text.trim());
    }
  }

  // ================= 原业务代码无缝保留 =================
  void togglePlay() {
    _isPlaying = !_isPlaying;
    player.playOrPause();
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    player.setVolume(_isMuted ? 0.0 : 100.0);
    notifyListeners();
  }

  void toggleAudioOnly(BuildContext context) {
    _isAudioOnly = !_isAudioOnly;
    notifyListeners();
    context.showAppToast(message: _isAudioOnly ? "已關閉視頻，進入純音頻模式" : "已恢復視頻畫面", type: AppToastType.info);
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

  @override
  void dispose() {
    _wsChannel?.sink.close();
    player.dispose();
    super.dispose();
  }
}
