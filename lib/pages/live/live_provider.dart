import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class LiveItem {
  final String title;
  final String status;
  final String coverUrl;
  LiveItem({required this.title, required this.status, required this.coverUrl});
}

class LiveProvider with ChangeNotifier {
  // --- 列表状态 ---
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  final List<LiveItem> _allLives = [
    LiveItem(title: '静心禅修直播', status: '直播中', coverUrl: ''),
    LiveItem(title: '午间修行提醒', status: '即将开始', coverUrl: ''),
    LiveItem(title: '昨日回顾直播', status: '已结束', coverUrl: ''),
  ];

  List<LiveItem> get filteredLives {
    if (_currentTabIndex == 0) return _allLives;
    String targetStatus = ['全部', '直播中', '即将开始', '已结束'][_currentTabIndex];
    return _allLives.where((item) => item.status == targetStatus).toList();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // --- 相机控制 (重点优化) ---
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isMicOn = true;
  bool isMirror = false;
  int selectedCameraIndex = 0;

  Future<void> initCamera() async {
    // 如果已经初始化过，不要重复执行，防止预览闪烁
    if (controller != null && controller!.value.isInitialized) return;
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        await _setupController();
      }
    } catch (e) {
      debugPrint("相机初始化失败: $e");
    }
  }

  Future<void> _setupController() async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      cameras![selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: true, // 始终开启硬件通道，避免切换麦克风状态时重启相机导致黑屏
    );

    await controller!.initialize();
    notifyListeners();
  }

  // 翻转摄像头 (硬件限制，必须重启，所以黑一下是正常的)
  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await _setupController();
  }

  // 切换麦克风 (优化：仅改变状态，不重启相机，解决黑屏问题)
  void toggleMic() {
    isMicOn = !isMicOn;
    notifyListeners();
  }

  void toggleMirror() {
    isMirror = !isMirror;
    notifyListeners();
  }

  void prepareLive() => notifyListeners();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // --- 🚀 补回丢失的弹幕逻辑 ---
  final List<Map<String, String>> _danmuList = [
    {'user': '系统', 'content': '欢迎来到直播间'},
  ];

  // 暴露给 UI 调用的 getter
  List<Map<String, String>> get danmuList => _danmuList;

  // 发送弹幕的方法
  void sendDanmu(String text) {
    if (text.trim().isEmpty) return;
    _danmuList.add({'user': '我', 'content': text});
    notifyListeners();
  }
}
