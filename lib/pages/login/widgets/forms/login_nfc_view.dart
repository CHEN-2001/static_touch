import 'dart:async'; // 引入计时器
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 引入Provider
import 'package:static_touch/pages/login/login_provider.dart'; // 你的Provider路径
import 'package:static_touch/pages/login/widgets/ripple_animation.dart';
import 'package:static_touch/services/nfc_service.dart';
import 'package:static_touch/models/result_entity.dart';

class LoginNfcView extends StatefulWidget {
  const LoginNfcView({super.key});

  @override
  State<LoginNfcView> createState() => _LoginNfcViewState();
}

class _LoginNfcViewState extends State<LoginNfcView> {
  // 定义一个变量来动态显示提示词
  String _hintText = "正在初始化...";
  Timer? _loadingTimer; // 定义动画计时器

  @override
  void initState() {
    super.initState();
    _autoCheckNfc();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel(); // 退出时销毁计时器
    NfcService.stopReading();
    super.dispose();
  }

  Future<void> _autoCheckNfc() async {
    ResultEntity result = await NfcService.checkStatus();

    if (result.status) {
      setState(() => _hintText = "正在感应...");

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
        onError: (err) => setState(() => _hintText = err),
      );
    } else {
      setState(() => _hintText = result.message);
    }
  }

  Future<void> _handleNfcLogin(String id) async {
    final loginProvider = context.read<LoginProvider>();
    ResultEntity resultEntity = await loginProvider.loginByNfc(id);
    _loadingTimer?.cancel();
    if (!mounted) return;
    if (resultEntity.status) {
      setState(() => _hintText = "登录成功");
      await NfcService.stopReading();
    } else {
      setState(() => _hintText = "登录失败，请重试");
      await Future.delayed(const Duration(seconds: 2));
      await NfcService.stopReading();
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
        // 这里使用了动态的 _hintText
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
