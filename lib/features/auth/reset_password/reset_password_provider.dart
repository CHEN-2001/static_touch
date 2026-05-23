import 'dart:async';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/features/auth/auth_repository.dart';

class ResetPasswordProvider extends BaseProvider {
  final AuthRepository _repo = locator<AuthRepository>();

  int _countdown = 0;
  int get countdown => _countdown;
  Timer? _timer;

  Future<bool> sendCaptcha(String email) async {
    if (email.trim().isEmpty) {
      setError("请输入您的注册邮箱"); // ✅ 直接调用基类方法，它会自动弹 Toast
      return false;
    }
    if (_countdown > 0) return false;

    setLoading(true);
    clearError();
    final res = await _repo.sendCaptcha(email);
    setLoading(false);

    if (res.status) {
      _startTimer();
      return true;
    } else {
      setError(res.message);
      return false;
    }
  }

  Future<bool> resetPassword({required String email, required String newPassword, required String captcha}) async {
    if (email.isEmpty || newPassword.isEmpty || captcha.isEmpty) {
      setError("请完整填写表单信息");
      return false;
    }

    setLoading(true);
    clearError();
    final res = await _repo.resetPassword(email: email, newPassword: newPassword, captcha: captcha);
    setLoading(false);

    if (res.status) {
      return true;
    } else {
      setError(res.message);
      return false;
    }
  }

  void _startTimer() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer?.cancel();
      } else {
        _countdown--;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
