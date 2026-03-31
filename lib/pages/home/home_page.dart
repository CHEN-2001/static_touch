import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/duration_card.dart';
import 'widgets/schedule_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 Scaffold 保证每一个子页面都有自己的 Material 容器
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: SafeArea(
        // 自动处理顶部状态栏遮挡
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // 增加 iOS 质感的滚动回弹
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: const [
              SizedBox(height: 20),
              HomeHeader(),
              SizedBox(height: 30),
              DurationCard(),
              SizedBox(height: 30),
              ScheduleList(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
