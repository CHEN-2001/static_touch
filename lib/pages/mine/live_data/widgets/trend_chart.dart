import 'package:flutter/material.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('近期开播粉丝趋势', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFDEEF1), borderRadius: BorderRadius.circular(10)),
                child: const Text('本周 +12%', style: TextStyle(color: Color(0xFFFF4D6A), fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // 趋势图占位 (建议后期接入 fl_chart)
          Container(
            height: 120,
            width: double.infinity,
            color: const Color(0xFFFDFBF7),
            child: const Center(
              child: Text('趋势折线图区域', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('02-26', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('03-01', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('今日', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
