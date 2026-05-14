import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/shared/providers/base_provider.dart'; // 🚀 引入基类

class LivePrepareProvider extends BaseProvider {
  // 🚀 继承基类
  CameraController? _controller;
  CameraController? get controller => _controller;

  List<CameraDescription> _cameras = [];
  bool _isMicOn = true;
  bool _isMirror = false;

  bool get isMicOn => _isMicOn;
  bool get isMirror => _isMirror;

  Future<void> initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      final frontCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _controller = CameraController(frontCamera, ResolutionPreset.high, enableAudio: _isMicOn);
      await _controller!.initialize();
      notifyListeners();
    } catch (e) {
      debugPrint('相机初始化失败: $e');
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2 || _controller == null) return;
    final lensDirection = _controller!.description.lensDirection;
    final newDirection = lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == newDirection,
      orElse: () => _cameras.first,
    );
    await _controller!.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.high, enableAudio: _isMicOn);
    await _controller!.initialize();
    notifyListeners();
  }

  void toggleMic() {
    _isMicOn = !_isMicOn;
    notifyListeners();
  }

  void toggleMirror() {
    _isMirror = !_isMirror;
    notifyListeners();
  }

  // 🚀 接入真实的业务逻辑与 Loading 状态
  Future<void> startBroadcast(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setLoading(true); // 🚀 触发基类的转圈状态

    final repo = locator<LiveRepository>();
    final result = await repo.createLiveRoom("我的静心直播");

    if (!context.mounted) return;

    if (result.status) {
      context.showAppToast(message: "开播成功，推流中...", type: AppToastType.success);
    } else {
      setError(result.message); // 🚀 触发基类的红色错误 Toast
    }

    setLoading(false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
