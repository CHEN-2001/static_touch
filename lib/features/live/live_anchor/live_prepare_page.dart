import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'widgets/live_prepare_toolbar.dart';
import 'live_prepare_provider.dart';

class LivePreparePage extends StatefulWidget {
  const LivePreparePage({super.key});

  @override
  State<LivePreparePage> createState() => _LivePreparePageState();
}

class _LivePreparePageState extends State<LivePreparePage> {
  @override
  void initState() {
    super.initState();
    // 确保组件渲染后初始化相机
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LivePrepareProvider>().initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<LivePrepareProvider>(
        builder: (context, p, child) {
          return Stack(
            fit: StackFit.expand, // 强制 Stack 撑满全屏
            children: [
              // 1. 底层：相机预览
              // 🚀 核心修复 3：强制转为 CameraController，满足 Flutter 严格的类型检查
              if (p.controller != null && (p.controller as CameraController).value.isInitialized)
                Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(p.isMirror ? 3.14159 : 0),
                    child: CameraPreview(p.controller as CameraController),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator(color: Colors.white24)),

              // 2. 顶层：控制 UI
              SafeArea(
                child: Column(
                  children: [
                    // 顶部返回
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
                        onPressed: () => debugPrint('开启直播，麦克风状态: ${p.isMicOn}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D6A),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 8,
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
          );
        },
      ),
    );
  }
}
