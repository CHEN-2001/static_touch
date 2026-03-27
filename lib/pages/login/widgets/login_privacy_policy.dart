import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_provider.dart';

class LoginPrivacyPolicy extends StatelessWidget {
  const LoginPrivacyPolicy({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isAgreed = context.watch<LoginProvider>().isAgreed;
    return GestureDetector(
      onTap: () => context.read<LoginProvider>().toggleAgreement(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAgreed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isAgreed ? const Color(0xFF8B2323) : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          const Text("我已阅读并同意用户协议与隐私政策", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
