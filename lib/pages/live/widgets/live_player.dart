import 'package:flutter/material.dart';

class LivePlayer extends StatelessWidget {
  const LivePlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text('自动播放视频加载中...', style: TextStyle(color: Colors.white70)),
          const Icon(Icons.play_arrow, color: Colors.white, size: 50),
          // 底部控制按钮
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.volume_up, color: Colors.white, size: 20),
                Icon(Icons.fullscreen, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
