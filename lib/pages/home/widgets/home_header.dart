import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //水平方向对齐方式
      crossAxisAlignment: CrossAxisAlignment.start, //垂直方向对齐方式
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '首页',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
            ),
            const SizedBox(height: 8),
            // 使用 Selector 实现局部刷新，性能最优
            Selector<HomeProvider, String>(
              selector: (_, p) => p.userName,
              builder: (_, name, __) => Text(
                '早安，$name',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
              ),
            ),
            const SizedBox(height: 4),
            Selector<HomeProvider, String>(
              selector: (_, p) => p.dailyQuote,
              builder: (_, quote, __) => Text(quote, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/notice'),
          behavior: HitTestBehavior.opaque, // 扩大点击灵敏度
          child: const Icon(Icons.notifications_none_rounded, size: 28, color: Color(0xFF4A2B11)),
        ),
      ],
    );
  }
}
