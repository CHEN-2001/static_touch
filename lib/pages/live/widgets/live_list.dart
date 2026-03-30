import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_provider.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 局部刷新：只监听过滤后的列表变化
    final items = context.select((LiveProvider p) => p.filteredLives);

    return ListView.builder(
      // 💡 大列表性能基础：必须指定 itemBuilder
      physics: const BouncingScrollPhysics(), // 增加 iOS 质感滚动回弹
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: items.length,
      itemBuilder: (context, index) => LiveCardItem(item: items[index]),
    );
  }
}

// 🚀 直播卡片组件（语义化拆解）
class LiveCardItem extends StatelessWidget {
  final LiveItem item;
  const LiveCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.black, // 占位图背景
        borderRadius: BorderRadius.circular(16),
      ),
      // 💡 关键：防止内部内容（图片）溢出圆角
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. 背景图（模拟网络图片）
          // Image.network(item.coverUrl, fit: BoxFit.cover, width: double.infinity),

          // 2. 状态标签（语义化局部布局）
          Positioned(top: 12, left: 12, child: _buildStatusTag(item.status)),

          // 3. 标题
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              '《${item.title}》占位符',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 状态标签局部 Widget（支持 const 优化）
  Widget _buildStatusTag(String status) {
    Color color = Colors.grey;
    if (status == '直播中') color = Colors.green;
    if (status == '未开始') color = Colors.orange;
    if (status == '已结束') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
