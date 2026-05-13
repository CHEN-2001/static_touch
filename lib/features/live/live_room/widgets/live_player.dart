import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_detail_provider.dart';

class LivePlayer extends StatelessWidget {
  const LivePlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final url = context.select((LiveDetailProvider p) => p.pullUrl);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            url == null ? '播放地址获取失败' : '视频流渲染中...\n$url',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
