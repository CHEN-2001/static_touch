import 'package:flutter/material.dart';

class DataSummary extends StatelessWidget {
  const DataSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B1F), // 深咖啡色
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildItem('总时长', '1,220', 'h'), _buildItem('总场次', '365', '场')],
      ),
    );
  }

  Widget _buildItem(String title, String value, String unit) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14)),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 28, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
