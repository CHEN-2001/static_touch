import 'package:flutter/material.dart';
import 'package:static_touch/shared/models/stats/stats_model.dart'; // 🚀 引入正规模型

// ================= 四宫格卡片组件 =================
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

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
                  style: const TextStyle(
                    color: valueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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

// ================= 趋势图表组件 =================
class TrendChart extends StatelessWidget {
  final List<ChartData> trendData;
  const TrendChart({super.key, required this.trendData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: trendData.map((data) => _buildBar(context, data)).toList(),
      ),
    );
  }

  Widget _buildBar(BuildContext context, ChartData data) {
    const Color activeColor = Color(0xFF8B2323);
    const Color goldColor = Color(0xFFD4AF37);

    double heightRatio = (data.minutes / 100).clamp(0.2, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16,
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: data.isToday ? activeColor : goldColor.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.label,
          style: TextStyle(
            fontSize: 11,
            color: data.isToday ? activeColor : Colors.grey,
            fontWeight: data.isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ================= 成就勋章组件 =================
class AchievementMedal extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isUnlocked;

  const AchievementMedal({
    super.key,
    required this.label,
    this.icon,
    required this.isUnlocked,
  });

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
            border: Border.all(color: medalColor.withOpacity(0.5), width: 2),
          ),
          child: isUnlocked
              ? Icon(
                  icon ?? Icons.workspace_premium,
                  color: medalColor,
                  size: 30,
                )
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
