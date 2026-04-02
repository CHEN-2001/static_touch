import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_provider.dart';

class LivePrepareToolbar extends StatelessWidget {
  const LivePrepareToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveProvider>();

    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 20),
      child: Column(
        children: [
          _toolItem(icon: Icons.flip_camera_ios, label: '翻转', onTap: () => p.switchCamera()),
          _toolItem(
            icon: p.isMicOn ? Icons.mic : Icons.mic_off,
            label: p.isMicOn ? '麦克风' : '已静音',
            onTap: () => p.toggleMic(),
            // 切换状态颜色变化，增强反馈
            iconColor: p.isMicOn ? Colors.white : Colors.redAccent,
          ),
          _toolItem(
            icon: Icons.auto_awesome_motion,
            label: '镜像',
            onTap: () => p.toggleMirror(),
            iconColor: p.isMirror ? Colors.blueAccent : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _toolItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
