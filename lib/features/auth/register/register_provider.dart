import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/auth/auth_repository.dart';

class RegisterProvider extends BaseProvider {
  final AuthRepository _repo = locator<AuthRepository>();

  int _countdown = 0;
  int get countdown => _countdown;
  Timer? _timer;

  Future<bool> sendCaptcha(String email, BuildContext context) async {
    if (email.trim().isEmpty) {
      context.showAppToast(message: "请输入电子邮箱", type: AppToastType.info);
      return false;
    }
    if (_countdown > 0) return false;

    setLoading(true);
    final res = await _repo.sendCaptcha(email);
    setLoading(false);

    if (res.status) {
      context.showAppToast(message: "验证码已发送", type: AppToastType.success);
      _startTimer();
      return true;
    } else {
      context.showAppToast(message: res.message ?? "发送失败", type: AppToastType.error);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String captcha,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty || captcha.isEmpty) {
      context.showAppToast(message: "请完整填写注册信息", type: AppToastType.info);
      return false;
    }

    setLoading(true);
    final res = await _repo.register(email: email, password: password, captcha: captcha);
    setLoading(false);

    if (res.status) {
      context.showAppToast(message: "注册成功，请登录", type: AppToastType.success);
      return true;
    } else {
      context.showAppToast(message: res.message ?? "注册失败", type: AppToastType.error);
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
