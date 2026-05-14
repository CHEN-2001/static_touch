import 'package:flutter/material.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/core/navigation/nav_service.dart';

abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMsg = '';

  // 🚀 核心防御：增加销毁生命周期标记
  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMsg.isNotEmpty;
  String get errorMsg => _errorMsg;

  @override
  void dispose() {
    _isDisposed = true; // 🚀 页面退出时，标记当前管家已阵亡
    super.dispose();
  }

  // 🚀 核心防御：重写底层刷新方法，如果管家已阵亡，直接吞掉刷新指令，防止红屏崩溃！
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners(); // 这里的调用也会被上面的安全机制保护
  }

  void setError(String message) {
    _errorMsg = message;
    _isLoading = false;
    notifyListeners();

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
