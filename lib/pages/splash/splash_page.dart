import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 模拟载入过程：停留 3 秒后跳转
    Timer(const Duration(seconds: 3), () {
      // 使用路由跳转到首页，并销毁当前载入页
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 这里以后可以换成你的视频或动画 Lottie
            CircularProgressIndicator(), // 加载动画
            SizedBox(height: 20),
            Text('私域直播系统载入中...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}