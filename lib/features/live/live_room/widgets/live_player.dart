import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import '../live_detail_provider.dart';

class LivePlayer extends StatefulWidget {
  const LivePlayer({super.key});

  @override
  State<LivePlayer> createState() => _LivePlayerState();
}

class _LivePlayerState extends State<LivePlayer> {
  bool _showControls = false; // 严格落实 PRD: 控制栏显示/隐藏状态

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDetailProvider>();
    final url = p.pullUrl;

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
            // 1. 底层：视频流或纯音频占位
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
                  : Text(
                      url == null ? '播放地址獲取失敗' : '視頻流渲染中...\n$url',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
            ),

            // 2. 顶层：播放器控制栏 (仅在点击时显示)
            if (_showControls)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
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
