import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:static_touch/core/utils/token_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // 🚀 2. 替换掉原来的无脑 Timer
  }

  Future<void> _checkAuthStatus() async {
    // 强制等待 2 秒（让你辛辛苦苦写的启动页动画能被看清）
    await Future.delayed(const Duration(seconds: 2));

    // 检查本地是否有 Token
    final bool isLogged = await TokenManager.isLoggedIn();

    if (!mounted) return;

    if (isLogged) {
      context.go('/main'); // 有钥匙，直接进主卧
    } else {
      context.go('/login'); // 没钥匙，去大门口
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF9E2A2B)), // 用主题色
            SizedBox(height: 20),
            Text('静触系统载入中...', style: TextStyle(fontSize: 18, color: Color(0xFF4A2B11))),
          ],
        ),
      ),
    );
  }
}
