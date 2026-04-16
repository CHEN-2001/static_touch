import 'package:flutter/material.dart';

class NfcProvider with ChangeNotifier {
  // 模拟设备数据
  String nfcName = "NFC 名称";
  String nfcId = "SN202303031234****";
  bool isBound = true;

  void unbindDevice() {
    print('执行解除设备绑定逻辑');
    // 未来在这里对接你的 ESP32 或后端 API
  }

  void enterLive() {
    print('执行一键进入直播逻辑');
  }
}
