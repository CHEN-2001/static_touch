import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // 消息推送
  bool _newMsgPush = true;
  bool get newMsgPush => _newMsgPush;

  // 直播提醒
  bool _liveStartRemind = true;
  bool get liveStartRemind => _liveStartRemind;

  // 自动打卡
  bool _autoCheckIn = true;
  bool get autoCheckIn => _autoCheckIn;

  // 后台播放
  bool _backgroundPlay = true;
  bool get backgroundPlay => _backgroundPlay;

  // 切换开关的方法
  void toggleMsgPush(bool value) {
    _newMsgPush = value;
    notifyListeners();
  }

  void toggleLiveRemind(bool value) {
    _liveStartRemind = value;
    notifyListeners();
  }

  void toggleAutoCheck(bool value) {
    _autoCheckIn = value;
    notifyListeners();
  }

  void toggleBgPlay(bool value) {
    _backgroundPlay = value;
    notifyListeners();
  }
}
