import 'package:flutter/material.dart';
import 'widgets/mine_header.dart';
import 'widgets/menu_card.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7), // 统一米色背景
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              MineHeader(), // 顶部
              SizedBox(height: 40),
              MenuCard(), // 功能列表
            ],
          ),
        ),
      ),
    );
  }
}
