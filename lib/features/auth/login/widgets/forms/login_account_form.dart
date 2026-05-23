import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/shared/widgets/scale_button.dart';
import 'package:static_touch/features/auth/login/login_provider.dart';
import 'package:static_touch/features/auth/login/widgets/login_input.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/routes/app_router.dart';

class LoginAccountForm extends StatefulWidget {
  const LoginAccountForm({super.key});

  @override
  State<LoginAccountForm> createState() => _LoginAccountFormState();
}

class _LoginAccountFormState extends State<LoginAccountForm> {
  final TextEditingController _accCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();

  @override
  void dispose() {
    _accCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final provider = context.read<LoginProvider>();

    if (!provider.isAgreed) {
      bool? isConfirm = await context.showAppDialog(
        title: "温馨提示",
        content: "请先阅读并同意隐私政策与服务协议",
        confirmText: "去同意",
        cancelText: "返回",
      );
      if (isConfirm == true) provider.toggleAgreement();
      return;
    }

    final success = await provider.login(_accCtrl.text.trim(), _pwdCtrl.text.trim());

    if (success && mounted) {
      context.showAppToast(message: "登录成功", type: AppToastType.success);
      context.go(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        LoginInput(label: '账号', controller: _accCtrl),
        LoginInput(label: '密码', isPassword: true, controller: _pwdCtrl),
        const SizedBox(height: 10),

        ScaleButton(
          onTap: provider.isLoading ? null : _handleLogin,
          child: Container(
            width: double.infinity,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: provider.isLoading ? Colors.grey : AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (!provider.isLoading)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: provider.isLoading
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScaleButton(
              onTap: () => context.push(AppRoutes.register), // 跳转到注册页面
              child: const Text('注册账号', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            ScaleButton(
              onTap: () => context.push(AppRoutes.resetPassword), // 跳转到忘记密码页面
              child: const Text('忘记密码？', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }
}
