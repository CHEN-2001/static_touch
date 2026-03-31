import 'package:flutter/material.dart';
import 'widgets/live_prepare_toolbar.dart';

class LivePreparePage extends StatelessWidget {
  const LivePreparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 相机未加载时的底色
      body: Stack(
        children: [
          // 1. 底层：相机预览占位 (未来接入 CameraPreview)
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: const Text('相机预览区域', style: TextStyle(color: Colors.white24)),
          ),

          // 2. 顶层：控制 UI
          SafeArea(
            child: Column(
              children: [
                // 顶部关闭
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // 右侧工具栏
                const Align(alignment: Alignment.topRight, child: LivePrepareToolbar()),

                const Spacer(),

                // 底部开启按钮
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                    onPressed: () => print('正式开启直播逻辑'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D6A), // 亮粉红色
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      '开启直播',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
