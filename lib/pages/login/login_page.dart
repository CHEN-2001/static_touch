import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/widgets/scale_button.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/login/widgets/login_logo.dart';
import 'package:static_touch/pages/login/widgets/forms/login_account_form.dart';
import 'package:static_touch/pages/login/widgets/forms/login_nfc_view.dart';
import 'package:static_touch/pages/login/widgets/login_privacy_policy.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const LoginLogo(),
                const SizedBox(height: 80),
                Container(
                  constraints: const BoxConstraints(minHeight: 380),
                  alignment: Alignment.topCenter,
                  child: loginProvider.isAccountLogin ? LoginAccountForm() : const LoginNfcView(),
                ),
                const SizedBox(height: 60),
                const Text('- 其他登录方式 -', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                _buildSwitchButton(loginProvider),
                const SizedBox(height: 40),
                const LoginPrivacyPolicy(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建切换按钮的私有方法
  Widget _buildSwitchButton(LoginProvider loginProvider) {
    return ScaleButton(
      onTap: () => loginProvider.switchLoginMethod(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(loginProvider.isAccountLogin ? Icons.nfc : Icons.person, color: const Color(0xFF8B2323), size: 30),
      ),
    );
  }
}
