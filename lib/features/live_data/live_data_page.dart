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
          style: TextStyle(
            color: Color(0xFF4A2B11),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF4A2B11),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF8B2323),
        backgroundColor: Colors.white,
        onRefresh: () async => await p.fetchStats(),
        child: p.isLoading && stats == null
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B2323)),
              )
            : stats == null
            ? ListView(children: const [Center(child: Text("暂无数据"))])
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  DataHeaderCard(
                    hours: stats.totalHours,
                    count: stats.totalCount,
                  ),

                  // 🚀 接入完美的平滑折线图
                  TrendChartCard(
                    rate: stats.trendRate,
                    dataPoints: stats.trendData,
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 16,
                              color: const Color(0xFF8B2323),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "历史记录",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2B11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 渲染列表
                        ...stats.history
                            .map((record) => HistoryItemTile(record: record))
                            .toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
      ),
    );
  }
}
