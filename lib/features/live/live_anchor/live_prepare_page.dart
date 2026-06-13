import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
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
      // 🚀 核心精简：这里再也不需要解析 extra 或者调用 loadScheduledData 了！
      // 因为 app_router 在创建 Provider 时，已经把模型数据塞进去了。
      // 这个页面只管做好本职工作：打开相机！
      context.read<LivePrepareProvider>().initCamera();
    });
  }

  void _handleStartButtonPressed(LivePrepareProvider p) async {
    if (p.isStreaming) {
      p.startBroadcast(context);
      return;
    }

    // 不管是“全新开播”还是“使用预告”，都会弹出确认框，并且会自动填入 p 里的现有数据
    final titleController = TextEditingController(text: p.title);
    final descController = TextEditingController(text: p.description);

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('开播确认', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          // 加上滚动防止键盘遮挡
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '直播标题',
                  hintText: '给直播起个吸引人的标题吧',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: '直播简介',
                  hintText: '简单介绍一下本次直播的内容...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
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

    // 如果用户点了取消，中断开播流程
    if (confirm != true) return;

    // 将最新的标题和简介更新到 Provider 中 (调用最新的 updateLiveInfo 方法)
    p.updateLiveInfo(titleController.text.trim(), descController.text.trim());

    if (!mounted) return;

    // 发起真正的推流请求
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
                        // 预告数据加载时锁定按钮
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
