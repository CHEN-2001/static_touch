import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/shared/providers/base_provider.dart';

class LivePrepareProvider extends BaseProvider {
  ApiVideoLiveStreamController? _controller;
  ApiVideoLiveStreamController? get controller => _controller;

  bool _isMicOn = true;
  bool _isMirror = false;
  bool _isStreaming = false; // 实时推流状态机

  bool get isMicOn => _isMicOn;
  bool get isMirror => _isMirror;
  bool get isStreaming => _isStreaming;

  // 模块化初始化推流引擎
  Future<void> initCamera() async {
    try {
      final videoConfig = VideoConfig.withDefaultBitrate(resolution: Resolution.RESOLUTION_720);
      final audioConfig = AudioConfig(bitrate: 128 * 1000);

      _controller = ApiVideoLiveStreamController(
        initialAudioConfig: audioConfig,
        initialVideoConfig: videoConfig,
        onConnectionSuccess: () {
          debugPrint('✅ [Engine] RTMP 握手成功，推流中');
          _isStreaming = true;
          notifyListeners();
        },
        onConnectionFailed: (error) {
          debugPrint('❌ [Engine] 建立连接失败: $error');
          setError('推流连接失败，请检查服务器状态');
          _isStreaming = false;
          setLoading(false);
          notifyListeners();
        },
        onDisconnection: () {
          debugPrint('⚠️ [Engine] 流已断开');
          _isStreaming = false;
          notifyListeners();
        },
      );

      await _controller!.initialize();
      notifyListeners();
    } catch (e) {
      setError('底层引擎初始化失败: $e');
    }
  }

  Future<void> switchCamera() async {
    if (_controller == null) return;
    await _controller!.switchCamera();
    notifyListeners();
  }

  void toggleMic() {
    if (_controller == null) return;
    _isMicOn = !_isMicOn;
    _controller!.toggleMute();
    notifyListeners();
  }

  void toggleMirror() {
    _isMirror = !_isMirror;
    notifyListeners();
  }

  // 核心推流控制逻辑
  Future<void> startBroadcast(BuildContext context) async {
    if (_controller == null) return;

    if (_isStreaming) {
      await _controller!.stopStreaming();
      if (context.mounted) context.showAppToast(message: "已结束推流", type: AppToastType.info);
      return;
    }

    setLoading(true);

    // 1. 业务层：获取推流鉴权/房间信息
    final repo = locator<LiveRepository>();
    final result = await repo.createLiveRoom("我的静心直播");

    if (!context.mounted) return;

    if (result.status) {
      try {
        debugPrint("🚀 [Engine] 启动推流器...");

        // 2. 引擎层：组装 RTMP 协议发起推流
        // 🚨 请修改为你真实的云服务器公网 IP
        await _controller!.startStreaming(streamKey: '123456', url: 'rtmp://47.92.105.53/live');

        context.showAppToast(message: "正在连接节点...", type: AppToastType.success);
      } catch (e) {
        setError("引擎装载失败: $e");
      }
    } else {
      setError(result.message);
    }

    setLoading(false);
  }

  @override
  void dispose() {
    _controller?.stopStreaming();
    _controller?.dispose();
    super.dispose();
  }
}
