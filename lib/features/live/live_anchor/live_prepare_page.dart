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
            fit: StackFit.expand,
            children: [
              // 1. 底层：相机预览
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Align(alignment: Alignment.topRight, child: LivePrepareToolbar()),
                    const Spacer(),

                    // 🚀 核心修复：绑定真实的提交逻辑与 Loading 动画
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        onPressed: p.isLoading ? null : () => p.startBroadcast(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D6A),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 8,
                        ),
                        child: p.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
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
