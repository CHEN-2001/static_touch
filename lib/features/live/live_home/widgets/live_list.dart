import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import '../live_provider.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key});

  // 🚀 新增：触发全局直播数据的静默刷新
  Future<void> _onRefresh(BuildContext context) async {
    // 无论在哪个 Tab 下拉，统一刷新全局数据池
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

    // 🚀 核心交互重构：只在列表区域套用下拉刷新
    return RefreshIndicator(
      color: const Color(0xFF8B2323),
      backgroundColor: Colors.white,
      onRefresh: () => _onRefresh(context),
      child: items.isEmpty
          // 🚀 细节优化：如果某个分类下没有数据，展示空状态，且依然保持可下拉刷新的能力！
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
          // 正常展示列表
          : ListView.builder(
              // 🚀 关键：即使数据只有一条不满一屏，也能强行拽下来刷新
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
          if (item.status == LiveStatus.live) {
            context.push(AppRoutes.liveDetail);
          } else {
            context.push(AppRoutes.meditationDetail, extra: item);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
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
