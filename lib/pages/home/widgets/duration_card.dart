import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // 🚀 必须引入，用于跳转
import '../home_provider.dart';

class DurationCard extends StatelessWidget {
  const DurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 使用 ClipRRect 确保 InkWell 的点击水波纹不超出圆角边框
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5E6CA)),
      ),
      child: InkWell(
        // 🚀 核心跳转逻辑：匹配你在 AppRouter 中定义的 path
        onTap: () => context.push('/stats'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('累计静心时长', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 10),
                  Selector<HomeProvider, int>(
                    selector: (_, p) => p.totalDuration,
                    builder: (_, duration, __) => Text(
                      '$duration 分钟',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2B11), // 统一你的禅意深褐色
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFFD4AF37), // 对应你 App 的金色
              ),
            ],
          ),
        ),
      ),
    );
  }
}
