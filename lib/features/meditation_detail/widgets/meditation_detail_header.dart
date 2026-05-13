import 'package:flutter/material.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/shared/models/live/live_detailed_model.dart';

class MeditationDetailHeader extends StatelessWidget {
  final MeditationScheduleModel data;

  const MeditationDetailHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final statusColor = data.status.color;
    final titleColor = const Color(0xFF4A2B11);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
            child: Text(
              data.status.tag,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            data.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor, height: 1.3),
          ),
        ],
      ),
    );
  }
}
