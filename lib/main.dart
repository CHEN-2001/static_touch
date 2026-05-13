import 'package:flutter/material.dart';
import 'package:static_touch/app.dart';
import 'package:static_touch/locator.dart';

void main() {
  // 全局注册/初始化
  setupLocator();
  runApp(const MyApp());
}
