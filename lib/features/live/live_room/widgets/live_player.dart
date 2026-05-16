import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:media_kit_video/media_kit_video.dart'; // 🚀 引入视频 UI
import '../live_detail_provider.dart';

class LivePlayer extends StatefulWidget {
  const LivePlayer({super.key});

  @override
  State<LivePlayer> createState() => _LivePlayerState();
}

class _LivePlayerState extends State<LivePlayer> {
  bool _showControls = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDetailProvider>();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. 底层：真正的视频流渲染！
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: p.isAudioOnly
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.headphones, color: Color(0xFFD4AF37), size: 40),
                        SizedBox(height: 10),
                        Text("純淨音頻模式運行中", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    )
                  : Video(
                      // 🚀 丢入控制器，开始渲染画面
                      controller: p.videoController,
                      controls: NoVideoControls, // 隐藏默认进度条，用我们自己的UI
                      fit: BoxFit.contain, // 保持画面比例
                    ),
            ),

            // 2. 顶层：播放器控制栏 (仅在点击时显示)
            if (_showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    // 播放/暂停
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        iconSize: 50,
                        icon: Icon(
                          p.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          color: Colors.white,
                        ),
                        onPressed: () => p.togglePlay(),
                      ),
                    ),
                    // 音量与全屏
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(p.isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 20),
                            onPressed: () => p.toggleMute(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                            onPressed: () => context.showAppToast(message: "全屏模式开发中", type: AppToastType.info),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
