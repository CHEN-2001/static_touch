import 'package:flutter/material.dart';
import 'package:static_touch/app.dart';
import 'package:static_touch/locator.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  // 全局注册/初始化
  setupLocator();
  //确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  //初始化音视频引擎
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}
