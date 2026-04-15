import 'package:flutter/material.dart';
import 'package:static_touch/models/live/live_detailed_model.dart';
import 'package:static_touch/enum/live_status_enum.dart';

class MeditationDetailInfoSection extends StatelessWidget {
  final MeditationScheduleModel data;
  const MeditationDetailInfoSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isFinished = data.status == LiveStatusEnum.finished;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("基础信息"),
          const SizedBox(height: 10),

          ...isFinished ? _buildFinishedRows() : _buildUpcomingRows(),

          const Divider(height: 40, color: Color(0xFFF2E7C2)),

          _buildSectionTitle("修行简介"),
          const SizedBox(height: 12),

          Text(
            data.description.isEmpty ? "暂无简介" : data.description,
            style: const TextStyle(color: Colors.grey, height: 1.6, fontSize: 14, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
    );
  }

  List<Widget> _buildFinishedRows() {
    return [
      _InfoRow(label: "开始时间", value: data.formatTime(data.actualStartTime)),
      _InfoRow(label: "结束时间", value: data.formatTime(data.actualEndTime)),
      _InfoRow(label: "修行时长", value: data.durationText),
      _InfoRow(label: "参与人数", value: "${data.viewers} 人"),
    ];
  }

  List<Widget> _buildUpcomingRows() {
    return [
      _InfoRow(label: "预计开始", value: data.formatTime(data.expectedStartTime)),
      _InfoRow(
        label: "当前状态",
        value: data.timeoutMinutes > 0 ? "已超时" : "未开始",
        subText: data.timeoutMinutes > 0 ? "（延迟${data.timeoutMinutes}分钟）" : null,
      ),
    ];
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? subText;

  const _InfoRow({required this.label, required this.value, this.subText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF4A2B11)),
                  ),
                ),
                if (subText != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      subText!,
                      style: const TextStyle(color: Color(0xFFA63232), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
