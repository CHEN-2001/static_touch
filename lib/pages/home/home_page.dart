import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('直播列表')),
      body: const Center(
        child: Text('欢迎来到主页', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}