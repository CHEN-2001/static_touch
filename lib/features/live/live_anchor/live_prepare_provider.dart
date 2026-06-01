import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 🚀 确保引入你的 SDK
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';

class LivePrepareProvider extends BaseProvider {
  final LiveRepository _liveRepo = locator<LiveRepository>();

  // ================= 摄像头与推流状态 =================
  ApiVideoLiveStreamController? _controller;
  ApiVideoLiveStreamController? get controller => _controller;

  bool _isMirror = false;
  bool get isMirror => _isMirror;

  bool _isMicOn = true;
  bool get isMicOn => _isMicOn;

  bool _isStreaming = false;
  bool get isStreaming => _isStreaming;

  // ================= 后端业务表单状态 =================
  String title = '静心修行直播'; // 默认标题
  String coverUrl = '';
  String notice = '';

  String? _liveId;
  String? get liveId => _liveId;

  // 🚀 接收从大厅传进来的预告ID
  String? _scheduledLiveId;

  String? get scheduledLiveId => _scheduledLiveId;

  void setScheduledLiveId(String? id) {
    _scheduledLiveId = id;
    notifyListeners();
  }

  // ================= 摄像头控制方法 =================

  Future<void> initCamera() async {
    try {
      _controller = ApiVideoLiveStreamController(
        initialAudioConfig: AudioConfig(),
        initialVideoConfig: VideoConfig.withDefaultBitrate(),
      );

      await _controller!.initialize();
      notifyListeners();
    } catch (e) {
      setError("相机初始化失败，请检查手机麦克风和摄像头权限");
    }
  }

  void switchCamera() {
    if (_controller != null) {
      _controller!.switchCamera();
      notifyListeners();
    }
  }

  void toggleMic() {
    if (_controller != null) {
      _isMicOn = !_isMicOn;
      notifyListeners();
    }
  }

  void toggleMirror() {
    _isMirror = !_isMirror;
    notifyListeners();
  }

  // ================= 核心：开播与关播联动 =================

  Future<void> startBroadcast(BuildContext context) async {
    if (_isStreaming) {
      await _stopBroadcast(context);
      return;
    }

    setLoading(true);
    clearError();
    try {
      // 🚀 直接去推流！如果是预告开播，这里会自动带上 _scheduledLiveId
      final result = await _liveRepo.startLive(
        title: title,
        coverUrl: coverUrl,
        scheduledLiveId: _scheduledLiveId, // 👈 关键点
      );

      if (result.status && result.data != null) {
        String? rtmpUrl;
        if (result.data is Map) {
          _liveId = result.data['id']?.toString();
          rtmpUrl = result.data['rtmpUrl']?.toString();
        } else {
          rtmpUrl = result.data.toString();
        }

        if (rtmpUrl == null || rtmpUrl.isEmpty) {
          setError("未获取到推流地址");
          return;
        }

        if (context.mounted && _liveId != null) {
          context.read<LiveStateProvider>().activateLiveState(liveId: _liveId!, isAnchor: true, rtmpUrl: rtmpUrl);
        }

        await _controller!.startStreaming(streamKey: "live", url: rtmpUrl);

        _isStreaming = true;
        notifyListeners();
      } else {
        setError(result.message);
      }
    } catch (e) {
      setError("推流引擎异常: $e");
    } finally {
      setLoading(false);
    }
  }

  void updateTitle(String newTitle) {
    title = newTitle;
  }

  /// 结束直播流程
  Future<void> _stopBroadcast(BuildContext context) async {
    setLoading(true);
    try {
      if (_controller != null) {
        try {
          await _controller!.stopStreaming();
        } catch (_) {
          await _controller!.stop();
        }
      }
      _isStreaming = false;

      if (context.mounted) {
        await context.read<LiveStateProvider>().leaveOrEndLive();
      }

      notifyListeners();
    } catch (e) {
      setError("结束直播发生异常");
    } finally {
      setLoading(false);
    }
  }

  // ================= 资源释放 =================
  @override
  void dispose() {
    try {
      _controller?.stopStreaming();
    } catch (_) {}
    super.dispose();
  }
}
