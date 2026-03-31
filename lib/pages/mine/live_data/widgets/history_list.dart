import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '历史记录',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
          ),
          const SizedBox(height: 16),
          _buildRecord('直播标题二', '昨天 8:00 直播时长32min'),
          _buildRecord('直播标题一', '3月2日 直播时长 60min'),
        ],
      ),
    );
  }

  Widget _buildRecord(String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Text('详细 >', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14)),
        ],
      ),
    );
  }
}
