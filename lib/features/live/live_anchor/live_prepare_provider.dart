import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import 'package:static_touch/shared/models/live/live_prepare_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class LivePrepareProvider extends BaseProvider {
  final LiveRepository _liveRepo = locator<LiveRepository>();

  ApiVideoLiveStreamController? _controller;
  ApiVideoLiveStreamController? get controller => _controller;

  bool _isMirror = false;
  bool get isMirror => _isMirror;

  bool _isMicOn = true;
  bool get isMicOn => _isMicOn;

  bool _isStreaming = false;
  bool get isStreaming => _isStreaming;

  // ================= 后端业务表单状态 =================
  String title = '静心修行直播';
  String description = '';
  String coverUrl = '';
  String notice = '';

  String? _liveId;
  String? get liveId => _liveId;

  String? _scheduledLiveId;
  String? get scheduledLiveId => _scheduledLiveId;

  Timer? _heartbeatTimer;

  // ================= 数据加载与更新 =================

  void init(LivePrepareModel? model) {
    if (model != null) {
      _scheduledLiveId = model.liveId?.toString();
      title = (model.title.isNotEmpty) ? model.title : '静心修行直播';
      description = model.description;
    }
    notifyListeners();
  }

  void updateLiveInfo(String newTitle, String newDesc) {
    title = newTitle;
    description = newDesc;
    notifyListeners();
  }

  // ================= 摄像头控制方法 (完全还原测试成功版) =================
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
          setLoading(false);
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

  void switchCamera() {
    if (_controller != null) {
      _controller!.switchCamera();
      notifyListeners();
    }
  }

  void toggleMic() {
    if (_controller != null) {
      _isMicOn = !_isMicOn;
      _controller!.toggleMute();
      notifyListeners();
    }
  }

  void toggleMirror() {
    _isMirror = !_isMirror;
    notifyListeners();
  }

  // ================= 核心：开播与关播联动 =================
  Future<void> startBroadcast(BuildContext context) async {
    if (_controller == null) return;

    if (_isStreaming) {
      await _stopBroadcast(context);
      return;
    }

    setLoading(true);
    clearError();
    try {
      // 1. 调用后端接口开播
      final result = await _liveRepo.startLive(
        title: title,
        description: description,
        coverUrl: coverUrl,
        scheduledLiveId: _scheduledLiveId,
      );

      if (result.status && result.data != null) {
        String? fullRtmpUrl;
        if (result.data is Map) {
          _liveId = result.data['liveId']?.toString();
          fullRtmpUrl = result.data['pushUrl']?.toString();
        } else {
          fullRtmpUrl = result.data.toString();
        }

        if (fullRtmpUrl == null || fullRtmpUrl.isEmpty) {
          setError("未获取到推流地址");
          setLoading(false);
          return;
        }

        // 🚀 2. 完美的切割逻辑（将推流地址分离给 SDK）
        String streamKey = "";
        String baseUrl = "";

        int lastSlashIndex = fullRtmpUrl.lastIndexOf('/');
        if (lastSlashIndex != -1 && lastSlashIndex > 7) {
          baseUrl = fullRtmpUrl.substring(0, lastSlashIndex);
          streamKey = fullRtmpUrl.substring(lastSlashIndex + 1);
        } else {
          baseUrl = fullRtmpUrl;
          streamKey = _liveId ?? "default";
        }

        if (context.mounted && _liveId != null) {
          context.read<LiveStateProvider>().activateLiveState(liveId: _liveId!, isAnchor: true, rtmpUrl: fullRtmpUrl);
        }

        // 🚀 3. 推流
        await _controller!.startStreaming(streamKey: streamKey, url: baseUrl);
        _startHeartbeat();
      } else {
        setError(result.message);
        setLoading(false);
      }
    } catch (e) {
      setError("推流引擎异常: $e");
      setLoading(false);
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_liveId != null && _isStreaming) {
        try {
          await _liveRepo.heartbeat(_liveId!);
        } catch (e) {
          debugPrint("心跳发送失败: $e");
        }
      }
    });
  }

  Future<void> _stopBroadcast(BuildContext context) async {
    setLoading(true);
    try {
      _heartbeatTimer?.cancel();

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
        context.showAppToast(message: "已结束推流", type: AppToastType.info);
      }

      notifyListeners();
    } catch (e) {
      setError("结束直播发生异常");
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    try {
      _controller?.stopStreaming();
      _controller?.dispose();
    } catch (_) {}
    super.dispose();
  }
}
