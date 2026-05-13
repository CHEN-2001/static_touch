import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/features/auth/login_provider.dart';

class LoginPrivacyPolicy extends StatelessWidget {
  const LoginPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<LoginProvider>().toggleAgreement(),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Selector<LoginProvider, bool>(
            selector: (_, provider) => provider.isAgreed,
            builder: (context, isAgreed, _) {
              return Icon(
                isAgreed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isAgreed ? const Color(0xFF8B2323) : Colors.grey,
                size: 18,
              );
            },
          ),
          const SizedBox(width: 8),
          const Text("我已阅读并同意用户协议与隐私政策", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
