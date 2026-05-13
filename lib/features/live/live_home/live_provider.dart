import 'package:flutter/material.dart';

class LiveProvider extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  final List<String> tabs = ['全部', '直播中', '即将开始', '已结束'];

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }
}
