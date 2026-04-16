import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'live_data_provider.dart';
import 'widgets/live_stats_cards.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveDataProvider>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDataProvider>();
    final stats = p.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "直播数据",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // 1. 顶部深色统计
                  DataHeaderCard(hours: stats.totalHours, count: stats.totalCount),

                  // 2. 趋势图占位 (白色圆角卡片)
                  _buildTrendPlaceholder(),

                  // 3. 历史记录列表
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 4, height: 16, color: const Color(0xFF8B2323)),
                            const SizedBox(width: 8),
                            const Text(
                              "历史记录",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...stats.history.map((record) => HistoryItemTile(record: record)).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildTrendPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Center(
        child: Text("近期开播热度趋势 (图表占位)", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
