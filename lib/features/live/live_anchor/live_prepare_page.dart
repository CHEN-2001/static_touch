import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart'; // 🚀 引入 Toast 扩展
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
      try {
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        if (extra != null && extra['scheduledLiveId'] != null) {
          context.read<LivePrepareProvider>().setScheduledLiveId(extra['scheduledLiveId'].toString());
        }
      } catch (e) {
        debugPrint("无附加参数，直接创建新直播");
      }

      context.read<LivePrepareProvider>().initCamera();
    });
  }

  void _handleStartButtonPressed(LivePrepareProvider p) async {
    if (p.isStreaming) {
      p.startBroadcast(context);
      return;
    }
    if (p.scheduledLiveId == null) {
      final titleController = TextEditingController(text: p.title);

      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('开播设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: '给直播起个吸引人的标题吧',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  context.showAppToast(message: '标题不能为空', type: AppToastType.warning);
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text(
                '确认开播',
                style: TextStyle(color: Color(0xFF8B2323), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      p.updateTitle(titleController.text.trim());
    }
    if (!mounted) return;
    p.startBroadcast(context);
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

              SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const Align(alignment: Alignment.topRight, child: LivePrepareToolbar()),
                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        onPressed: p.isLoading ? null : () => _handleStartButtonPressed(p),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.isStreaming ? Colors.grey : const Color(0xFF8B2323),
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
