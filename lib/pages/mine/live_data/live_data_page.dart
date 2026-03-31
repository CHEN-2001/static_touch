import 'package:flutter/material.dart';
import 'widgets/data_summary.dart';
import 'widgets/trend_chart.dart';
import 'widgets/history_list.dart';

class LiveDataPage extends StatelessWidget {
  const LiveDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '直播数据',
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            DataSummary(), // 深色汇总卡片
            TrendChart(), // 趋势图
            HistoryList(), // 历史记录
          ],
        ),
      ),
    );
  }
}
