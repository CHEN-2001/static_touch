import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/mine/live_data/live_data_provider.dart';
import 'package:static_touch/features/mine/live_data/widgets/live_stats_cards.dart';
import 'package:go_router/go_router.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    // 初始化 Tab 控制器，支持手势左右滑动切换
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    // 🚀 优化3：监听滑动距离，超过 300px 显示“回到顶部”按钮
    _scrollController.addListener(() {
      if (_scrollController.offset >= 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset < 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveDataProvider>().fetchStats(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动回顶部方法
  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDataProvider>();
    final stats = p.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "直播数据统计",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      // 🚀 悬浮按钮：一键回到顶部
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: const Color(0xFF8B2323),
              mini: true,
              elevation: 4,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : null,
      body: p.isLoading && stats == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B2323)))
          : RefreshIndicator(
              color: const Color(0xFF8B2323),
              backgroundColor: Colors.white,
              onRefresh: () async => await p.fetchStats(isRefresh: true),
              // 🚀 优化1：核心！使用 NestedScrollView 实现头部图表滚动隐藏与 Tab 吸顶
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    // 上方的统计卡片 (随滑动滚出屏幕)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          if (stats != null) ...[
                            DataHeaderCard(hours: stats.totalHours, count: stats.totalCount),
                            TrendChartCard(rate: stats.trendRate, dataPoints: stats.trendData),
                          ],
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    // 🚀 优化2：Tab 吸顶！滚下去时会像钉子一样钉在屏幕顶端
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: const Color(0xFF4A2B11),
                          unselectedLabelColor: Colors.grey.shade400,
                          indicatorColor: const Color(0xFF8B2323),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: "待开播"),
                            Tab(text: "历史记录"),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                // 下方的独立列表区域
                body: TabBarView(
                  controller: _tabController,
                  children: [_buildUpcomingList(context, p.upcomingLives), _buildHistoryList(context, p)],
                ),
              ),
            ),
    );
  }

  /// 🔴 待开播列表：改用虚拟懒加载 `ListView.builder`
  Widget _buildUpcomingList(BuildContext context, List upcomingLives) {
    if (upcomingLives.isEmpty) {
      return const Center(
        child: Text("暂无待开播的预告房间", style: TextStyle(color: Colors.grey, fontSize: 14)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: upcomingLives.length,
      itemBuilder: (context, index) {
        final item = upcomingLives[index];
        final rawTime = item['expectedStartTime']?.toString() ?? '';
        final displayTime = rawTime.contains('T') ? rawTime.replaceAll('T', ' ').substring(0, 16) : rawTime;
        final liveId = item['id']?.toString() ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  item['title']?.toString() ?? '未命名预告',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text("预计时间: $displayTime", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFDEEF1), borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    "准备中",
                    style: TextStyle(color: Color(0xFFFF4D6A), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final confirm = await context.showAppDialog(
                          title: '取消预告',
                          content: '确定要取消该直播预告吗？\n取消后观众将不再看到此房间。',
                          confirmText: '确认取消',
                        );
                        if (confirm == true && context.mounted) {
                          context.read<LiveDataProvider>().cancelSchedule(context, liveId);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text('取消预告', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.livePrepare, extra: {'scheduledLiveId': liveId});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B2323),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 32),
                        elevation: 0,
                      ),
                      child: const Text('去开播', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔵 历史记录列表：懒加载 + 滑到底部静默分页
  Widget _buildHistoryList(BuildContext context, LiveDataProvider p) {
    final stats = p.stats;
    if (stats == null || stats.history.isEmpty) {
      return const Center(
        child: Text("暂无历史直播记录", style: TextStyle(color: Colors.grey, fontSize: 14)),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // 当列表滑动到底部时，触发加载下一页
        if (!p.isLoading && p.hasMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
          p.fetchStats(isRefresh: false);
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: stats.history.length + 1, // 多一个底部 Loading 占位符
        itemBuilder: (context, index) {
          // 如果到了最后一个项，显示加载状态
          if (index == stats.history.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: p.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B2323)),
                      )
                    : Text(
                        p.hasMore ? "上拉加载更多历史记录" : "没有更多历史记录了",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
              ),
            );
          }
          // 渲染你的历史记录卡片
          return HistoryItemTile(record: stats.history[index]);
        },
      ),
    );
  }
}

/// ============================================================================
/// 吸顶 TabBar 委托类 (保障背景色不透明，阻挡列表穿透)
/// ============================================================================
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  _StickyTabBarDelegate(this.child);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF9F9F9), // 必须要设定与页面一致的背景色，否则文字会重叠
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // 结构固定，不需要重复渲染
  }
}
