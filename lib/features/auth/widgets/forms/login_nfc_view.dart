import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/features/auth/login_provider.dart';
import 'package:static_touch/features/auth/widgets/ripple_animation.dart';
import 'package:static_touch/features/nfc/nfc_service.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 需要用来弹成功Toast

class LoginNfcView extends StatefulWidget {
  const LoginNfcView({super.key});

  @override
  State<LoginNfcView> createState() => _LoginNfcViewState();
}

class _LoginNfcViewState extends State<LoginNfcView> {
  String _hintText = "正在初始化...";
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _autoCheckNfc();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    NfcService.stopReading();
    super.dispose();
  }

  Future<void> _autoCheckNfc() async {
    final result = await NfcService.checkStatus();

    if (result.status) {
      if (mounted) setState(() => _hintText = "正在感应...");

      NfcService.startReading(
        onSuccess: (String id) {
          if (!mounted) return;
          int dotCount = 0;
          _loadingTimer?.cancel();
          _loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
            dotCount = (dotCount + 1) % 4;
            if (mounted) setState(() => _hintText = "登录中${"." * dotCount}");
          });
          _handleNfcLogin(id);
        },
        onError: (err) {
          if (mounted) setState(() => _hintText = err);
        },
      );
    } else {
      if (mounted) setState(() => _hintText = result.message);
    }
  }

  Future<void> _handleNfcLogin(String id) async {
    final provider = context.read<LoginProvider>();

    // 🚀 UI 层等待布尔值
    final success = await provider.loginByNfc(id);

    _loadingTimer?.cancel();
    if (!mounted) return;

    if (success) {
      setState(() => _hintText = "登录成功");
      context.showAppToast(message: "NFC 识别成功", type: AppToastType.success);
      context.go(AppRoutes.main);
    } else {
      setState(() => _hintText = "登录失败，请重试");
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) _autoCheckNfc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RippleAnimation(
          child: Image.asset(
            'assets/images/nfc.png',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.nfc, size: 80, color: Color(0xFF8B2323)),
          ),
        ),
        Text(
          _hintText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 15),
        const Text("请靠近 NFC 感应区", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text(
          "将您的NFC或感应设备\n贴近手机背面顶部",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
        ),
      ],
    );
  }
}
