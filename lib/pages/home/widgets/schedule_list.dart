import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// 导入 provider、model、enum
import 'package:static_touch/providers/live_state_provider.dart';
import 'package:static_touch/models/live_item_model.dart';
import 'package:static_touch/enum/live_status_enum.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveListProvider>().initAndRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<LiveItemModel> items = context.select((LiveListProvider p) => p.items);
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
              onTap: () => context.push('/livePrepare'),
              child: const Text(
                '进入直播',
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

  // 页面跳转
  void _handleItemTap(BuildContext context, LiveItemModel item) {
    switch (item.status) {
      case LiveStatusEnum.finished:
      case LiveStatusEnum.upcoming:
        context.push('/meditationDetail', extra: item);
        break;
      case LiveStatusEnum.ongoing:
        context.push('/liveDetailPage');
        break;
    }
  }

  // 组件渲染样式
  Widget _buildItem(BuildContext context, LiveItemModel item) {
    return GestureDetector(
      onTap: () => _handleItemTap(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: item.status.color, width: 1.5),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: item.status.color, borderRadius: BorderRadius.circular(20)),
              child: Text(item.status.tag, style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const SizedBox(width: 15),
            Text(
              _getActionTextByStatus(item.status),
              style: TextStyle(color: item.status.color, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 映射列表点击功能文字
  String _getActionTextByStatus(LiveStatusEnum listen) {
    switch (listen.value) {
      case 1:
        return '进入直播';
      default:
        return '查看详细';
    }
  }
}
