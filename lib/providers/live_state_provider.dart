import 'package:flutter/material.dart';
import 'package:static_touch/models/live_item.dart';
import 'package:static_touch/services/live_service.dart';

class LiveListProvider with ChangeNotifier {
  final LiveService _liveService = LiveService();

  List<LiveItem> _items = [];
  bool _isLoading = false;

  // 只读属性
  List<LiveItem> get items => _items;
  bool get isLoading => _isLoading;

  // 初始化或下拉刷新
  Future<void> refreshLiveList() async {
    _isLoading = true;
    notifyListeners(); // 告诉 UI 显示加载动画

    try {
      _items = await _liveService.fetchLiveListFromApi();
    } catch (e) {
      debugPrint("加载直播列表失败: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // 刷新完成，隐藏加载动画
    }
  }
}
