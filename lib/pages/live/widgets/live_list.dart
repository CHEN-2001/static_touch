import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. 导入路由插件
import 'package:provider/provider.dart';
import 'package:static_touch/pages/live/live_provider.dart';
import 'package:static_touch/pages/home/home_provider.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 局部刷新：只监听过滤后的列表变化
    final items = context.select((LiveProvider p) => p.filteredLives);

    return ListView.builder(
      // 💡 大列表性能基础：必须指定 itemBuilder
      physics: const BouncingScrollPhysics(), // 增加 iOS 质感滚动回弹
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) => LiveCardItem(item: items[index]),
    );
  }
}

// 🚀 直播卡片组件
class LiveCardItem extends StatelessWidget {
  final LiveItem item;
  const LiveCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 2. 使用 InkWell 包裹，提供点击反馈
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          // 这里的映射逻辑要确保 import 了 ScheduleStatus 枚举所在的 home_provider.dart
          if (item.status == '直播中') {
            context.push('/liveDetailPage');
          } else {
            // 统一分发到详情页
            context.push(
              '/meditationDetail',
              extra: {
                'title': item.title,
                'status': item.status == '已结束' ? ScheduleStatus.finished : ScheduleStatus.upcoming,
                'startTime': DateTime.now(), // 建议在 LiveItem 模型中加入具体时间字段
              },
            );
          }
        },
        borderRadius: BorderRadius.circular(16), // 水波纹裁切圆角
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black, // 占位图背景
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          // 💡 关键：防止内部内容（图片）溢出圆角
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. 背景图占位（此处可以换成真实的图片组件，如 Image.network）
              Container(color: Colors.black87),

              // 2. 状态标签（语义化局部布局）
              Positioned(top: 12, left: 12, child: _buildStatusTag(item.status)),

              // 3. 标题
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  '《${item.title}》', // 移除“占位符”文字
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // 💡 文字阴影：增强复杂背景下的易读性
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 状态标签局部 Widget（支持 const 优化）
  Widget _buildStatusTag(String status) {
    // 生产建议颜色值（枣红、橄榄绿、琥珀金）
    Color color = Colors.grey;
    if (status == '直播中') color = const Color(0xFF6B8E23); // 橄榄绿
    if (status == '未开始') color = const Color(0xFFDAA520); // 琥珀金
    if (status == '已结束') color = const Color(0xFF8B2323); // 枣红

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
