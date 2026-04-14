import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/models/live_item_model.dart';
import 'package:static_touch/widgets/app_dialogs.dart';
import 'package:static_touch/pages/shared/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/models/live_detailed_model.dart';
import 'package:static_touch/enum/live_status_enum.dart';

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
    final p = context.watch<MeditationDetailProvider>();
    final data = p.detail;
    if (data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    const themeRed = Color(0xFF8B2323);
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
            // 头部：标题与状态标签
            _buildHeader(data, themeRed),

            // 核心信息区：严谨分流
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "基础信息",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                  ),
                  const SizedBox(height: 10),

                  // --- 状态分流开始 ---
                  if (isFinished) ...[
                    // 已结束：只显示结果数据
                    _infoRow("开始时间", data.formatTime(data.actualStartTime)),
                    _infoRow("结束时间", data.formatTime(data.actualEndTime)),
                    _infoRow("修行时长", data.durationText),
                    _infoRow("参与人数", "${data.viewers} 人"),
                  ] else ...[
                    // 未开始：显示计划和超时
                    _infoRow("预计开始", data.formatTime(data.expectedStartTime)),
                    _infoRow(
                      "当前状态",
                      data.timeoutMinutes > 0 ? "已超时" : "未开始",
                      subText: data.timeoutMinutes > 0 ? "（延迟${data.timeoutMinutes}分钟）" : null,
                    ),
                  ],

                  // --- 状态分流结束 ---
                  const Divider(height: 40, color: Color(0xFFF2E7C2)),

                  const Text(
                    "修行简介",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                  ),
                  const SizedBox(height: 12),
                  Text(data.description, style: const TextStyle(color: Colors.grey, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, data, p, themeRed),
    );
  }

  Widget _buildHeader(MeditationScheduleModel data, Color red) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: data.status.color, borderRadius: BorderRadius.circular(4)),
            child: Text(
              data.status.tag,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {String? subText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF4A2B11)),
              ),
              if (subText != null)
                Text(
                  subText,
                  style: const TextStyle(color: Color(0xFFA63232), fontSize: 13, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, MeditationScheduleModel data, MeditationDetailProvider p, Color red) {
    bool isFinished = data.status == LiveStatusEnum.finished;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: isFinished
          ? ElevatedButton(
              onPressed: () => context.showAppToast(message: "回放加载中...", type: AppToastType.success),
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "查看回放",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : OutlinedButton(
              onPressed: () async {
                bool? confirm = await context.showAppDialog(title: "设置提醒", content: "课程开始前将提醒您。");
                if (confirm == true) {
                  p.toggleRemind('1');
                  context.showAppToast(message: "设置成功", type: AppToastType.success);
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: p.isReminded ? Colors.grey : red),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                p.isReminded ? "已设置提醒" : "提醒我",
                style: TextStyle(color: p.isReminded ? Colors.grey : red, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
