import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 🚀 引入弹窗用于未开始提示
import '../live_provider.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key}); // 🚀 恢复无参构造，完美兼容你的 live_page.dart

  // 触发全局直播数据的静默刷新
  Future<void> _onRefresh(BuildContext context) async {
    await context.read<LiveStateProvider>().refreshLiveList();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 拿到全局数据池
    final allItems = context.select((LiveStateProvider p) => p.items);
    // 2. 拿到当前选中的 Tab
    final tabIndex = context.select((LiveProvider p) => p.currentTabIndex);

    // 3. 本地纯函数过滤，绝不产生二次网络请求
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
                      children: [
                        Icon(Icons.inbox_rounded, size: 60, color: Colors.black12),
                        SizedBox(height: 16),
                        Text('暂无该状态的直播', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: items.length,
              itemBuilder: (context, index) => _LiveCardItem(item: items[index]),
            ),
    );
  }
}

class _LiveCardItem extends StatelessWidget {
  final LiveItemModel item;
  const _LiveCardItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          // 🚀 核心修复：严格遵循 PRD 文档的路由分发逻辑
          if (item.status == LiveStatus.live) {
            context.push(AppRoutes.liveDetail);
          } else if (item.status == LiveStatus.preparing) {
            // 🚀 未开始：只弹提示，不乱跳转
            context.showAppToast(message: "直播尚未开始，已为您设置开播提醒", type: AppToastType.info);
          } else {
            // 🚀 回放：带上参数跳详情
            context.push(AppRoutes.meditationDetail, extra: item);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            // 🚀 拥抱 withValues 新语法
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(color: Colors.black87), // 占位背景
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
