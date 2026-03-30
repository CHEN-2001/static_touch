import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('首页', style: TextStyle(color: Colors.grey, fontSize: 14)),
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
        const Icon(Icons.notifications_none_rounded, size: 28),
      ],
    );
  }
}
