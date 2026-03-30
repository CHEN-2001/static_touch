import 'package:flutter/material.dart';

class MineProvider with ChangeNotifier {
  // 目前先放空逻辑，保证页面能跑通
  void refresh() {
    notifyListeners();
  }
}
