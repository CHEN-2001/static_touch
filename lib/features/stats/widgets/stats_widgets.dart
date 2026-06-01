import 'package:flutter/material.dart';
import 'package:static_touch/shared/models/stats/meditation_stats_model.dart';

// ================= 四宫格卡片组件 =================
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const StatCard({super.key, required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    const Color valueColor = Color(0xFF8B2323);
    const Color unitColor = Colors.grey;
    const Color borderColor = Color(0xFFF0E6D2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: unitColor, fontSize: 13)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(color: unitColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 趋势图表组件 (带气泡点击交互) =================
class TrendChart extends StatefulWidget {
  final List<WeeklyTrendModel> trendData;
  const TrendChart({super.key, required this.trendData});

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  // 记录当前被点击悬浮的是哪一根柱子
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 160,
      // 点击图表空白区域，隐藏弹出的气泡
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() => _selectedIndex = null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widget.trendData.asMap().entries.map((entry) {
            return _buildBar(context, entry.value, entry.key);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, WeeklyTrendModel data, int index) {
    const Color activeColor = Color(0xFF8B2323);
    const Color goldColor = Color(0xFFD4AF37);

    // 计算柱体高度比例，最高 100%，最低 20% 打底
    double heightRatio = (data.minutes / 100).clamp(0.01, 1.0);

    // 获取当前时间并组装成 05-25 的后端横线格式
    final now = DateTime.now();
    final String todayStr = '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 剔除两端隐形空格，防脏数据
    final String cleanDate = data.date.trim();

    // 判断是否是今天
    bool isToday = (cleanDate == todayStr) || (cleanDate == '今日');

    // 判断这根柱子是否被用户点击选中了
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      // 点击柱子切换气泡显示状态
      onTap: () => setState(() => _selectedIndex = isSelected ? null : index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 悬浮气泡 (带透明度动画，更丝滑)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.9), // 半透明红色气泡底色
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${data.minutes}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 核心柱体
          Container(
            width: 16,
            height: 100 * heightRatio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isToday ? activeColor : goldColor.withValues(alpha: 0.4),
            ),
          ),

          const SizedBox(height: 10),

          // 底部日期文字
          Text(
            isToday ? '今日' : cleanDate,
            style: TextStyle(
              fontSize: 11,
              color: isToday ? activeColor : Colors.grey,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 成就勋章组件 =================
class AchievementMedal extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isUnlocked;

  const AchievementMedal({super.key, required this.label, this.icon, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    const Color medalColor = Color(0xFFD4AF37);

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? Colors.transparent : const Color(0xFFF5F5F5),
            border: Border.all(color: medalColor.withValues(alpha: 0.5), width: 2),
          ),
          child: isUnlocked
              ? Icon(icon ?? Icons.workspace_premium, color: medalColor, size: 30)
              : const Center(
                  child: Text(
                    '未解\n锁',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
