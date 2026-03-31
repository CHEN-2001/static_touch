import 'package:flutter/material.dart';

class LivePrepareToolbar extends StatelessWidget {
  const LivePrepareToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          _buildIcon(Icons.flip_camera_ios_outlined),
          const SizedBox(height: 24),
          _buildIcon(Icons.mic_none_rounded),
          const SizedBox(height: 24),
          _buildIcon(Icons.title_rounded), // 对应图片中的 T (文字)
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black26, // 微弱阴影背景增强可见度
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
