import 'package:flutter/material.dart';

class NoticeProvider with ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void markAllAsRead() {
    print('一键已读逻辑');
    // 这里未来处理数据状态更新
  }
}
