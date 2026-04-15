import 'package:flutter/material.dart';
import 'package:static_touch/services/user_service.dart';
import 'package:static_touch/models/user/user_model.dart';
import 'package:static_touch/services/time_service.dart';

class UserStateProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel _user = UserModel.empty();
  String _dailyQuote = "";
  int _totalDuration = 0;
  UserModel get user => _user;
  String get dailyQuote => _dailyQuote;
  int get totalDuration => _totalDuration;

  String get greeting => TimeService.getGreeting();

  Future<void> initData() async {
    try {
      final data = await _userService.fetchUserInfo();
      _user = data;
      _dailyQuote = data.dailyQuote;
      _totalDuration = data.totalDuration;
    } catch (e) {
      debugPrint("数据加载失败: $e");
    } finally {
      notifyListeners();
    }
  }
}
