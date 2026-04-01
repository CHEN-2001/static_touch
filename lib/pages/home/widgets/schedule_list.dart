import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 导入路由
import 'package:provider/provider.dart';
import 'package:static_touch/pages/home/home_provider.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select((HomeProvider p) => p.scheduleItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '今日静心时刻表',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A2B2B)),
            ),
            GestureDetector(
              // 假设“进入当前直播”直接跳转到正在进行的直播
              onTap: () => context.push('/livePrepare'),
              child: const Text(
                '进入当前直播',
                style: TextStyle(color: Color(0xFF8B2323), fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildItem(context, item)),
      ],
    );
  }

  // 点击条目的核心分发逻辑
  void _handleItemTap(BuildContext context, ScheduleItem item) {
    switch (item.status) {
      case ScheduleStatus.finished:
        // 已结束：跳转详情页，并携带参数（如 ID）
        context.push('/livePrepare');
        break;
      case ScheduleStatus.ongoing:
        // 进行中：跳转直播准备页或直播间
        context.push('/livePrepare');
        break;
      case ScheduleStatus.upcoming:
        // 未开始：跳转发布信息页/提醒设置（这里先跳转到 notice 演示）
        context.push('/livePrepare');
        break;
    }
  }

  Widget _buildItem(BuildContext context, ScheduleItem item) {
    final statusColor = _getStatusColor(item.status);

    return GestureDetector(
      // 整个卡片都可以点击
      onTap: () => _handleItemTap(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: statusColor.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Text(
              item.timeDisplay,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF444444)),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
            ),
            // 状态标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
              child: Text(item.statusText, style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const SizedBox(width: 15),
            // 右侧动作按钮（视觉提示）
            Text(
              _getActionText(item.status),
              style: TextStyle(
                color: statusColor.withValues(alpha: item.canAction ? 1.0 : 0.4),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ScheduleStatus status) {
    switch (status) {
      case ScheduleStatus.finished:
        return const Color(0xFFD3D3D3);
      case ScheduleStatus.ongoing:
        return const Color(0xFF6B8E23);
      case ScheduleStatus.upcoming:
        return const Color(0xFFDAA520);
    }
  }

  String _getActionText(ScheduleStatus status) {
    switch (status) {
      case ScheduleStatus.finished:
        return '详细';
      case ScheduleStatus.ongoing:
        return '进入';
      case ScheduleStatus.upcoming:
        return '提醒';
    }
  }
}
