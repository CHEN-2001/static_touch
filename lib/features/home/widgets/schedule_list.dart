import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/widgets/skeleton_block.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 🚀 引入弹窗工具

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    await Future.wait([
      context.read<UserStateProvider>().initData(isSilent: true),
      context.read<LiveStateProvider>().refreshLiveList(),
    ]);
  }

  void _handleQuickEnter(BuildContext context, List<LiveItemModel> items) {
    if (items.isEmpty) {
      context.showAppToast(message: "今日暂无直播安排", type: AppToastType.warning);
      return;
    }

    // 1. 优先寻找正在直播的场次（从上往下第一场）
    int liveIdx = items.indexWhere((e) => e.status == LiveStatus.live);
    if (liveIdx != -1) {
      _handleItemTap(context, items[liveIdx]);
      return;
    }

    // 2. 其次寻找即将开始的预告
    int prepIdx = items.indexWhere((e) => e.status == LiveStatus.preparing);
    if (prepIdx != -1) {
      _handleItemTap(context, items[prepIdx]);
      return;
    }

    // 3. 兜底方案：全都结束了，直接进入最近的一场（列表第一项）
    _handleItemTap(context, items.first);
  }

  // 统一的条目跳转分发中心
  void _handleItemTap(BuildContext context, LiveItemModel item) {
    switch (item.status) {
      case LiveStatus.ended:
      case LiveStatus.preparing:
        context.push(AppRoutes.meditationDetail, extra: item);
        break;
      case LiveStatus.live:
        context.push(AppRoutes.liveDetail);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<LiveItemModel> items = context.select((LiveStateProvider p) => p.items);

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
              onTap: () => _handleQuickEnter(context, items),
              behavior: HitTestBehavior.opaque,
              child: const Text(
                '快捷进入',
                style: TextStyle(color: Color(0xFF8B2323), fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF8B2323),
            backgroundColor: Colors.white,
            onRefresh: () => _onRefresh(context),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: items.isEmpty ? 2 : items.length,
              itemBuilder: (context, index) {
                if (items.isEmpty) return _buildSkeletonItem();
                return _buildItem(context, items[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: const Row(
        children: [
          SkeletonBlock(width: 50, height: 20),
          SizedBox(width: 20),
          Expanded(child: SkeletonBlock(height: 20)),
          SizedBox(width: 15),
          SkeletonBlock(width: 40, height: 20),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, LiveItemModel item) {
    return GestureDetector(
      onTap: () => _handleItemTap(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF444444)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: item.status.color, borderRadius: BorderRadius.circular(20)),
              child: Text(item.status.tag, style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const SizedBox(width: 12),
            Text(
              _getActionTextByStatus(item.status),
              style: TextStyle(color: item.status.color, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _getActionTextByStatus(LiveStatus status) {
    switch (status) {
      case LiveStatus.live:
        return '进入直播';
      default:
        return '查看详细';
    }
  }
}
