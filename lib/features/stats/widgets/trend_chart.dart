import 'package:flutter/material.dart';
import '../models/stats_model.dart';

class TrendChart extends StatelessWidget {
  final List<ChartData> trendData;
  const TrendChart({super.key, required this.trendData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 160,
      // 🚀 取消 SingleChildScrollView，直接平铺
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: trendData.map((data) => _buildBar(context, data)).toList(),
      ),
    );
  }

  Widget _buildBar(BuildContext context, ChartData data) {
    const Color activeColor = Color(0xFF8B2323); // 禅意红
    const Color goldColor = Color(0xFFD4AF37); // 禅意金

    // 根据分钟数计算高度比例（假设最大高度 100）
    double heightRatio = (data.minutes / 100).clamp(0.2, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 柱状图主体
        Container(
          width: 16, // 稍微加宽一点，平铺更好看
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: data.isToday ? activeColor : goldColor.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 10),
        // 日期文字
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
