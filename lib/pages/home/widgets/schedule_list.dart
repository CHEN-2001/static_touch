import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select((HomeProvider p) => p.scheduleItems);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('今日静心时刻表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('进入当前直播', style: TextStyle(color: Color(0xFF8B2323), fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildItem(item)).toList(),
      ],
    );
  }

  Widget _buildItem(ScheduleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(item.time, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          Expanded(child: Text(item.title)),
          Text(item.status, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
