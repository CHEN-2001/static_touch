import 'package:flutter/material.dart';

class MainTabProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<String> tabTitles = ['首页', '直播', '我的', '设置'];

  final List<IconData> tabIcons = [
    Icons.home_rounded,
    Icons.live_tv_rounded,
    Icons.person_rounded,
    Icons.settings_rounded,
  ];

  void switchTab(int index, PageController pageController) {
    if (_currentIndex != index) {
      _currentIndex = index;
      pageController.jumpToPage(index); // 同步切换 PageView
      notifyListeners(); // 触发 UI 局部刷新
    }
  }
}
