import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stats_provider.dart';
import 'widgets/stat_card.dart';
import 'widgets/trend_chart.dart';
import 'widgets/achievement_medal.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>().stats;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            // 🚀 这里把“滑动查看”去掉了，只留标题
            const Text(
              '一周趋势',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
            ),
            const SizedBox(height: 20),

            // 柱状图
            TrendChart(trendData: stats.weeklyTrend),

            const SizedBox(height: 40),
            const Text(
              '修行成就',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
            ),
            const SizedBox(height: 20),

            // 成就勋章
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AchievementMedal(label: '成就1', isUnlocked: true),
                AchievementMedal(label: '成就2', isUnlocked: true),
                AchievementMedal(label: '成就3', isUnlocked: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
