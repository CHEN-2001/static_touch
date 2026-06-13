import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/live/live_home/live_provider.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key});

  /// 核心注释：触发下拉刷新，重新拉取今日的直播时刻表数据
  Future<void> _onRefresh(BuildContext context) async {
    await context.read<LiveProvider>().fetchTodaySchedule(isSilent: true);
  }

  /// 核心注释：处理卡片点击事件。直播中状态会激活全局直播状态，并通过 extra 传递对应的房间 ID
  void _handleItemTap(BuildContext context, LiveItemModel item) {
    switch (item.status) {
      case LiveStatus.live:
        // 激活观众端的全局基础直播状态流
        context.read<LiveStateProvider>().activateLiveState(liveId: item.id, isAnchor: false);
        // 🚀 修复：将当前直播的 id 通过 extra 塞给路由跳转
        context.push(AppRoutes.liveDetail, extra: item.id);
        break;
      case LiveStatus.preparing:
        context.showAppToast(message: "直播尚未开始，已为您设置开播提醒", type: AppToastType.info);
        break;
      case LiveStatus.ended:
        context.push(AppRoutes.meditationDetail, extra: item);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = context.select((LiveProvider p) => p.scheduleItems);
    final tabIndex = context.select((LiveProvider p) => p.currentTabIndex);

    // 核心注释：根据当前选中的 Tab 栏状态索引，在本地做高效率的同步数组条件过滤
    List<LiveItemModel> items;
    switch (tabIndex) {
      case 1:
        items = allItems.where((e) => e.status == LiveStatus.live).toList();
        break;
      case 2:
        items = allItems.where((e) => e.status == LiveStatus.preparing).toList();
        break;
      case 3:
        items = allItems.where((e) => e.status == LiveStatus.ended).toList();
        break;
      default:
        items = allItems;
    }

    return RefreshIndicator(
      color: const Color(0xFF8B2323),
      backgroundColor: Colors.white,
      onRefresh: () => _onRefresh(context),
      child: items.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) => ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  Container(
                    height: constraints.maxHeight,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('暂无该状态的直播', style: TextStyle(color: Colors.grey, fontSize: 14))],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _LiveCardItem(item: items[index], onTap: () => _handleItemTap(context, items[index])),
            ),
    );
  }
}

/// ============================================================================
/// 下方为优化解耦后的内部卡片渲染组件
/// ============================================================================
class _LiveCardItem extends StatelessWidget {
  final LiveItemModel item;
  final VoidCallback onTap;

  const _LiveCardItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(color: Colors.black87), // 纯黑底色占位背景
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: item.status.color, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    item.status.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  '《${item.title}》',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
}
