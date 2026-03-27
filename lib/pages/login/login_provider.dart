import 'package:flutter/material.dart';
import 'package:static_touch/models/result_entity.dart';

class LoginProvider extends ChangeNotifier {
  //  页面私有状态
  bool _isAgreed = false;
  bool _isAccountLogin = true;
  bool _isLoading = false;

  //  暴露 Getter 给 UI 使用
  bool get isAgreed => _isAgreed;
  bool get isAccountLogin => _isAccountLogin;
  bool get isLoading => _isLoading;

  //  方法事件
  // 切换协议勾选
  void toggleAgreement() {
    _isAgreed = !_isAgreed;
    notifyListeners(); // 📢 广播通知 UI 更新
  }

  // 切换登录方式 (NFC/账号)
  void switchLoginMethod() {
    _isAccountLogin = !_isAccountLogin;
    notifyListeners();
  }

  // 登录管理逻辑
  Future<ResultEntity> login(String account, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      return ResultEntity(true, '登录成功');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // NFC 快速登录
  Future<ResultEntity> loginByNfc(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      return ResultEntity(true, '登录成功');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
