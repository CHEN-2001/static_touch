import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'widgets/stats_widgets.dart'; // 🚀 统一引入聚合组件

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStateProvider>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserStateProvider>();
    final stats = p.stats;
    const darkTextColor = Color(0xFF4A2B11);

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '静心记录',
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF8B2323),
        backgroundColor: Colors.white,
        onRefresh: () async => await p.initData(),
        child: p.isLoading && stats == null
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B2323)))
            : stats == null
            ? ListView(children: const [Center(child: Text("暂无数据"))])
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  // 四宫格统计
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.6,
                    children: [
                      StatCard(title: '累计修行', value: '${stats.totalDays}', unit: '天'),
                      StatCard(title: '连续打卡', value: '${stats.streakDays}', unit: '天'),
                      StatCard(title: '总时长', value: '${stats.totalMinutes}', unit: '分'),
                      StatCard(title: '本周修行', value: '${stats.thisWeekMinutes}', unit: '分'),
                    ],
                  ),
                  const SizedBox(height: 35),

                  const Text(
                    '一周趋势',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                  ),
                  const SizedBox(height: 20),
                  if (stats.weeklyTrend.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text("暂无记录", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    )
                  else
                    TrendChart(trendData: stats.weeklyTrend),
                  const SizedBox(height: 40),
                  const Text(
                    '修行成就',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AchievementMedal(label: '初入静门', isUnlocked: true),
                      AchievementMedal(label: '连续七日', isUnlocked: true),
                      AchievementMedal(label: '百时之境', isUnlocked: false),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
