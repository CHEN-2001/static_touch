import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 🚀 引入图表库
import 'package:static_touch/shared/models/live/live_data_model.dart';

// ================= 1. 顶部深色统计卡片 =================
class DataHeaderCard extends StatelessWidget {
  final String hours;
  final int count;
  const DataHeaderCard({super.key, required this.hours, required this.count});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2F24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat("总时长", hours, "h", goldColor),
          _buildStat("总场次", "$count", "场", goldColor),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.8), fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(unit, style: TextStyle(color: color, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

// ================= 2. 趋势折线图卡片 =================
class TrendChartCard extends StatelessWidget {
  final String rate;
  final List<TrendPoint> dataPoints;
  const TrendChartCard({
    super.key,
    required this.rate,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '近期开播精进趋势',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEEF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rate,
                  style: const TextStyle(
                    color: Color(0xFFFF4D6A),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: LineChart(_buildChartData()),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < dataPoints.length; i++) {
      spots.add(FlSpot(i.toDouble(), dataPoints[i].value));
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 &&
                  index < dataPoints.length &&
                  dataPoints[index].label.isNotEmpty) {
                return Text(
                  dataPoints[index].label,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true, // 平滑折线
          color: const Color(0xFF8B2323),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => spot.y == 60, // 仅在最高点显示圆点
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 3,
                  color: const Color(0xFFD4AF37),
                  strokeWidth: 0,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B2323).withOpacity(0.15),
                const Color(0xFF8B2323).withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

// ================= 3. 历史记录行组件 =================
class HistoryItemTile extends StatelessWidget {
  final LiveHistoryRecord record;
  const HistoryItemTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          record.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A2B11),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "${record.timeLabel} 直播时长${record.durationMinutes}min",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "详细",
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward, color: Color(0xFFD4AF37), size: 16),
          ],
        ),
        onTap: () => _showDetailBottomSheet(context, record), // 🚀 点击触发详情弹窗
      ),
    );
  }

  // 🚀 核心 UI：高还原度的详情弹窗
  void _showDetailBottomSheet(BuildContext context, LiveHistoryRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFBF7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                record.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2B11),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "场次日期：${record.fullDate}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // 2x2 网格
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: [
                  _detailBox("单场时长", "${record.durationMinutes}min"),
                  _detailBox("观看人数", "${record.viewers}"),
                  _detailBox("评论互动", "${record.comments}"),
                  _detailBox("打卡人数", "${record.checkIns}"),
                ],
              ),
              const SizedBox(height: 30),
              // 底部按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A2B11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "知道了",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _detailBox(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.4),
          width: 1,
        ), // 金色边框
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF4A2B11),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
