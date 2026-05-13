import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/models/live/live_data_model.dart'; // 🚀 路径修正
import 'package:static_touch/shared/enum/live_status_enum.dart';

// 🚀 顶部深色统计卡片
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
      decoration: BoxDecoration(color: const Color(0xFF3D2F24), borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_buildStat("总时长", hours, "h", goldColor), _buildStat("总场次", "$count", "场", goldColor)],
      ),
    );
  }

  Widget _buildStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Text(unit, style: TextStyle(color: color, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

// 🚀 历史记录行组件
class HistoryItemTile extends StatelessWidget {
  final LiveHistoryRecord record;
  const HistoryItemTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          record.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
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
              style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.chevron_right, color: Color(0xFFD4AF37), size: 20),
          ],
        ),
        onTap: () {
          context.push(
            '/meditationDetail',
            extra: {'title': record.title, 'status': LiveStatus.ended, 'startTime': DateTime.now()},
          );
        },
      ),
    );
  }
}
