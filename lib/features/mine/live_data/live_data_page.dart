import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // 🚀 新增路由引入
import 'package:static_touch/routes/app_router.dart'; // 🚀 新增路由引入
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 🚀 新增弹窗引入
import 'package:static_touch/shared/models/live/live_data_model.dart';
import 'live_data_provider.dart';
import 'widgets/live_stats_cards.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveDataProvider>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDataProvider>();
    final stats = p.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "直播数据",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF8B2323),
        backgroundColor: Colors.white,
        onRefresh: () async => await p.fetchStats(),
        child: p.isLoading && stats == null
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B2323)))
            : stats == null
            ? ListView(children: const [Center(child: Text("暂无数据"))])
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  DataHeaderCard(hours: stats.totalHours, count: stats.totalCount),
                  TrendChartCard(rate: stats.trendRate, dataPoints: stats.trendData),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LiveRecordTabsSection(stats: stats, upcomingLives: p.upcomingLives),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
      ),
    );
  }
}

class LiveRecordTabsSection extends StatefulWidget {
  final LiveDataModel stats;
  final List<dynamic> upcomingLives;

  const LiveRecordTabsSection({super.key, required this.stats, required this.upcomingLives});

  @override
  State<LiveRecordTabsSection> createState() => _LiveRecordTabsSectionState();
}

class _LiveRecordTabsSectionState extends State<LiveRecordTabsSection> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    const Color activeRed = Color(0xFF8B2323);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTabItem("待开播", 0, activeRed),
            const SizedBox(width: 24),
            _buildTabItem("历史记录", 1, activeRed),
          ],
        ),
        const SizedBox(height: 20),
        _currentTab == 0 ? _buildUpcomingList() : _buildHistoryList(),
      ],
    );
  }

  Widget _buildTabItem(String title, int index, Color activeColor) {
    final isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF4A2B11) : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 核心修改：为待开播卡片底部注入操作栏
  Widget _buildUpcomingList() {
    if (widget.upcomingLives.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text("暂无待开播的预告房间", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      );
    }

    return Column(
      children: widget.upcomingLives.map((item) {
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
              // 基础信息区块
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
              // 🚀 新增：底部操作栏区块
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
                        // 🚀 对接现有的路由，把 scheduledLiveId 传给开播准备页
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
      }).toList(),
    );
  }

  Widget _buildHistoryList() {
    if (widget.stats.history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text("暂无历史直播记录", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      );
    }
    return Column(children: widget.stats.history.map((record) => HistoryItemTile(record: record)).toList());
  }
}
