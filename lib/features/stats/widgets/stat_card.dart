import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const StatCard({super.key, required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    // 统一视觉配置
    const Color valueColor = Color(0xFF8B2323); // 禅意红
    const Color unitColor = Colors.grey;
    const Color borderColor = Color(0xFFF0E6D2); // 米黄色边框

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
