import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/widgets/scale_button.dart';
import 'package:static_touch/features/auth/login/widgets/login_input.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'register_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _captchaCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _captchaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: Consumer<RegisterProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("注册账号", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  const Text("开启您的修行之旅", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 50),

                  LoginInput(label: '邮箱', controller: _emailCtrl),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: LoginInput(label: '验证码', controller: _captchaCtrl),
                      ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ScaleButton(
                          onTap: () => provider.sendCaptcha(_emailCtrl.text, context),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: provider.countdown > 0
                                  ? Colors.grey.withValues(alpha: 0.2)
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              provider.countdown > 0 ? "${provider.countdown}s" : "获取验证码",
                              style: TextStyle(
                                color: provider.countdown > 0 ? Colors.grey : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  LoginInput(label: '设置密码', isPassword: true, controller: _pwdCtrl),
                  const SizedBox(height: 40),

                  ScaleButton(
                    onTap: provider.isLoading
                        ? null
                        : () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final success = await provider.register(
                              email: _emailCtrl.text.trim(),
                              password: _pwdCtrl.text.trim(),
                              captcha: _captchaCtrl.text.trim(),
                              context: context,
                            );
                            if (success && context.mounted) context.pop();
                          },
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
                              '注 册',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
