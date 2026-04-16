import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:static_touch/models/live/live_item_model.dart';
import 'package:static_touch/services/live_service.dart';
import 'package:static_touch/enum/live_status_enum.dart';

class LiveProvider with ChangeNotifier {
  final LiveService _liveService = LiveService();

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  List<LiveItemModel> _allLives = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LiveItemModel> get filteredLives {
    if (_currentTabIndex == 0) return _allLives;
    Map<int, LiveStatusEnum> targetStatus = {
      1: LiveStatusEnum.ongoing,
      2: LiveStatusEnum.upcoming,
      3: LiveStatusEnum.finished,
    };
    return _allLives.where((item) => item.status == targetStatus[_currentTabIndex]).toList();
  }

  Future<void> fetchLives() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allLives = await _liveService.fetchLiveListFromApi();
    } catch (e) {
      debugPrint("获取列表失败: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // --- 2. 相机控制 (防抖优化) ---
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isMicOn = true;
  bool isMirror = false;
  int selectedCameraIndex = 0;
  bool _isCameraInitializing = false; // 加把锁，防止重复初始化

  Future<void> initCamera() async {
    if (_isCameraInitializing) return;
    if (controller != null && controller!.value.isInitialized) return;

    _isCameraInitializing = true;
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        await _setupController();
      }
    } catch (e) {
      debugPrint("相机初始化失败: $e");
    } finally {
      _isCameraInitializing = false;
    }
  }

  Future<void> _setupController() async {
    // 销毁旧的，释放内存
    await controller?.dispose();

    controller = CameraController(cameras![selectedCameraIndex], ResolutionPreset.high, enableAudio: true);

    await controller!.initialize();
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await _setupController();
  }

  // 纯 UI 状态切换
  void toggleMic() {
    isMicOn = !isMicOn;
    notifyListeners();
  }

  void toggleMirror() {
    isMirror = !isMirror;
    notifyListeners();
  }

  // --- 3. 弹幕逻辑 (简单直接) ---
  final List<Map<String, String>> _danmuList = [
    {'user': '系统', 'content': '欢迎来到直播间'},
  ];
  List<Map<String, String>> get danmuList => _danmuList;

  void sendDanmu(String text) {
    if (text.trim().isEmpty) return;
    _danmuList.add({'user': '我', 'content': text});
    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
