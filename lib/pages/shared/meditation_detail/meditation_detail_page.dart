import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/models/live/live_item_model.dart';
import 'package:static_touch/pages/shared/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/pages/shared/meditation_detail/widgets/meditation_detail_header.dart';
import 'package:static_touch/pages/shared/meditation_detail/widgets/meditation_detail_info_section.dart';
import 'package:static_touch/pages/shared/meditation_detail/widgets/meditation_detail_bottom_bar.dart';
import 'package:static_touch/enum/live_status_enum.dart'; // 建议引入枚举

class MeditationDetailPage extends StatefulWidget {
  final LiveItemModel item;
  const MeditationDetailPage({super.key, required this.item});

  @override
  State<MeditationDetailPage> createState() => _MeditationDetailPageState();
}

class _MeditationDetailPageState extends State<MeditationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeditationDetailProvider>().loadDetail(widget.item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 外层直接包 Consumer，监控整个页面的数据加载
    return Consumer<MeditationDetailProvider>(
      builder: (context, provider, child) {
        final data = provider.detail;

        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('加载中...'), backgroundColor: Colors.white, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final bool isFinished = data.status == LiveStatusEnum.finished;

        return Scaffold(
          backgroundColor: const Color(0xFFFDFBF7),
          appBar: AppBar(
            title: Text(isFinished ? '课程回顾' : '课程详情'),
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: const Color(0xFF4A2B11),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                MeditationDetailHeader(data: data),
                MeditationDetailInfoSection(data: data),
              ],
            ),
          ),
          bottomNavigationBar: const MeditationDetailBottomBar(),
        );
      },
    );
  }
}
