import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/features/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/features/meditation_detail/widgets/meditation_detail_header.dart';
import 'package:static_touch/features/meditation_detail/widgets/meditation_detail_info_section.dart';
import 'package:static_touch/features/meditation_detail/widgets/meditation_detail_bottom_bar.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';

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
    return Consumer<MeditationDetailProvider>(
      builder: (context, provider, child) {
        final data = provider.detail;

        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('加载中...'), backgroundColor: Colors.white, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // 🚀 修改点：改成判断 LiveStatus.ended
        final bool isFinished = data.status == LiveStatus.ended;

        return Scaffold(
          backgroundColor: const Color(0xFFFDFBF7),
          appBar: AppBar(
            title: Text(isFinished ? '课程回顾' : '课程详情1'),
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
