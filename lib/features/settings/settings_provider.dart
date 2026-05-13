import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool newMsgPush = true;
  bool liveStartRemind = true;
  bool autoCheckIn = false;
  bool backgroundPlay = true;

  void toggleMsgPush(bool val) {
    newMsgPush = val;
    notifyListeners();
  }

  void toggleLiveRemind(bool val) {
    liveStartRemind = val;
    notifyListeners();
  }

  void toggleAutoCheck(bool val) {
    autoCheckIn = val;
    notifyListeners();
  }

  void toggleBgPlay(bool val) {
    backgroundPlay = val;
    notifyListeners();
  }
}
