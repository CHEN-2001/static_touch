import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/shared/widgets/scale_button.dart';
import 'package:static_touch/features/auth/login/login_provider.dart';
import 'package:static_touch/features/auth/login/widgets/login_logo.dart';
import 'package:static_touch/features/auth/login/widgets/forms/login_account_form.dart';
import 'package:static_touch/features/auth/login/widgets/forms/login_nfc_view.dart';
import 'package:static_touch/features/auth/login/widgets/login_privacy_policy.dart';
import 'package:static_touch/shared/theme/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const LoginLogo(),
                const SizedBox(height: 80),
                Selector<LoginProvider, bool>(
                  selector: (_, provider) => provider.isAccountLogin,
                  builder: (context, isAccountLogin, _) {
                    return Container(
                      constraints: const BoxConstraints(minHeight: 380),
                      alignment: Alignment.topCenter,
                      child: isAccountLogin ? const LoginAccountForm() : const LoginNfcView(),
                    );
                  },
                ),

                const SizedBox(height: 60),
                const Text('- 其他登录方式 -', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                _buildSwitchButton(context),
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

  // 底部切换按钮
  Widget _buildSwitchButton(BuildContext context) {
    return Selector<LoginProvider, bool>(
      selector: (_, provider) => provider.isAccountLogin,
      builder: (context, isAccountLogin, _) {
        return ScaleButton(
          onTap: () => context.read<LoginProvider>().switchLoginMethod(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(isAccountLogin ? Icons.nfc : Icons.person, color: AppColors.zenRed, size: 30),
          ),
        );
      },
    );
  }
}
