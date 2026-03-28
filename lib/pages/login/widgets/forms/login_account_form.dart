import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/widgets/app_dialogs.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/login/widgets/login_input.dart';
import 'package:static_touch/widgets/scale_button.dart';
import 'package:static_touch/models/result_entity.dart';
import 'package:go_router/go_router.dart';

class LoginAccountForm extends StatefulWidget {
  const LoginAccountForm({super.key});

  @override
  State<LoginAccountForm> createState() => _LoginAccountFormState();
}

class _LoginAccountFormState extends State<LoginAccountForm> {
  final TextEditingController _accCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();

  Future<void> _handleLogin() async {
    final loginProvider = context.read<LoginProvider>();

    if (!loginProvider.isAgreed) {
      bool? isConfirm = await context.showAppDialog(
        title: "温馨提示",
        content: "请先阅读并同意隐私政策与服务协议",
        confirmText: "去同意",
        cancelText: "返回",
      );
      if (!mounted) return;
      if (isConfirm == true) {
        loginProvider.toggleAgreement();
      }
      return;
    }
    if (_accCtrl.text.trim().isEmpty || _pwdCtrl.text.trim().isEmpty) {
      context.showAppToast(message: "账号或密码不能为空", type: AppToastType.warning, position: AppToastPosition.top);
      return;
    }
    ResultEntity resultEntity = await loginProvider.login(_accCtrl.text.trim(), _pwdCtrl.text.trim());
    if (!mounted) return;
    if (resultEntity.status) {
      context.go('/home');
    } else {
      context.showAppToast(message: "账号或密码错误", type: AppToastType.error, position: AppToastPosition.top);
    }
  }

  @override
  void dispose() {
    _accCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        LoginInput(label: '账号', controller: _accCtrl),
        LoginInput(label: '密码', isPassword: true, controller: _pwdCtrl),
        const SizedBox(height: 10),
        ScaleButton(
          onTap: loginProvider.isLoading ? null : _handleLogin,
          child: Container(
            width: double.infinity,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: loginProvider.isLoading ? Colors.grey : const Color(0xFF9E2A2B),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (!loginProvider.isLoading)
                  BoxShadow(
                    color: const Color(0xFF9E2A2B).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: loginProvider.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    '登 录',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
          ),
        ),

        const SizedBox(height: 30),

        // 底部跳转按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScaleButton(
              onTap: () {
                /* 导航到注册页 */
              },
              child: const Text('注册账号', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            ScaleButton(
              onTap: () {
                /* 导航到找回密码 */
              },
              child: const Text('忘记密码？', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }
}
