import 'package:flutter/material.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/core/navigation/nav_service.dart';

abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMsg = '';

  bool get isLoading => _isLoading;
  String get errorMsg => _errorMsg;
  bool get hasError => _errorMsg.isNotEmpty;

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  // 接管报错处理，自动获取全局 Context 弹红色 Toast
  void setError(String message) {
    _errorMsg = message;
    setLoading(false);

    final context = NavService.rootNavigatorKey.currentContext;
    if (context != null) {
      context.showAppToast(message: message, type: AppToastType.error);
    }
  }

  void clearError() {
    if (_errorMsg.isEmpty) return;
    _errorMsg = '';
    notifyListeners();
  }
}
