import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/widgets/skeleton_block.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/home/home_provider.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  /// 核心注释：下拉刷新，并行更新用户信息与今日日程数据
  Future<void> _onRefresh(BuildContext context) async {
    await Future.wait([
      context.read<UserStateProvider>().initData(isSilent: true),
      context.read<HomeProvider>().fetchTodaySchedule(isSilent: true),
    ]);
  }

  /// 核心注释：快捷进入逻辑，按状态优先级（直播中 > 准备中 > 第一条数据）自动分流进入
  void _handleQuickEnter(BuildContext context, List<LiveItemModel> items) {
    if (items.isEmpty) {
      context.showAppToast(message: "今日暂无直播安排", type: AppToastType.warning);
      return;
    }

    int liveIdx = items.indexWhere((e) => e.status == LiveStatus.live);
    if (liveIdx != -1) {
      _handleItemTap(context, items[liveIdx]);
      return;
    }

    int prepIdx = items.indexWhere((e) => e.status == LiveStatus.preparing);
    if (prepIdx != -1) {
      _handleItemTap(context, items[prepIdx]);
      return;
    }

    _handleItemTap(context, items.first);
  }

  /// 核心注释：点击单项，直播中同步激活直播全局状态并进房间，其它状态进入静心详情页
  void _handleItemTap(BuildContext context, LiveItemModel item) {
    switch (item.status) {
      case LiveStatus.ended:
      case LiveStatus.preparing:
        context.push(AppRoutes.meditationDetail, extra: item);
        break;
      case LiveStatus.live:
        context.read<LiveStateProvider>().activateLiveState(liveId: item.id, isAnchor: false);
        context.push(AppRoutes.liveDetail, extra: item.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final items = provider.scheduleItems;
    final isLoading = provider.isLoading;

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
            child: _buildListContent(isLoading, items),
          ),
        ),
      ],
    );
  }

  /// 核心注释：根据加载状态与数组空实，分流渲染骨架屏、无数据兜底或真实列表视图
  Widget _buildListContent(bool isLoading, List<LiveItemModel> items) {
    if (isLoading && items.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) => _buildSkeletonItem(),
      );
    }

    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text("今日暂无静心列表", style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItem(context, items[index]),
    );
  }

  /// 核心注释：骨架屏组件，用于网络未就绪前的布局占位
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

  /// 核心注释：基于直播模型状态渲染的具体单项卡片组件
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

  /// 核心注释：根据状态返回对应动作文本（直播中为进入，其它为详情）
  String _getActionTextByStatus(LiveStatus status) {
    switch (status) {
      case LiveStatus.live:
        return '进入直播';
      default:
        return '查看详细';
    }
  }
}
