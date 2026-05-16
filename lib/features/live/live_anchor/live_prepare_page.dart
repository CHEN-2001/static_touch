import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
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
              // 渲染层：底层引擎画面输出
              if (p.controller != null)
                Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(p.isMirror ? 3.14159 : 0),
                    child: ApiVideoCameraPreview(controller: p.controller!),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator(color: Colors.white24)),

              // 交互层：控制遮罩与操作流
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

                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        onPressed: p.isLoading ? null : () => p.startBroadcast(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.isStreaming ? Colors.grey : const Color(0xFFFF4D6A),
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
                            : Text(
                                p.isStreaming ? '结束直播' : '开启直播',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
