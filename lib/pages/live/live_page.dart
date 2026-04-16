import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // 必须引入
import 'package:static_touch/pages/live/widgets/live_tabs.dart';
import 'package:static_touch/pages/live/widgets/live_list.dart';
import 'package:static_touch/widgets/scale_button.dart';
import 'package:static_touch/pages/live/live_provider.dart';

// 1. 将 StatelessWidget 改为 StatefulWidget，为了使用 initState
class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LiveProvider>().fetchLives();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LiveTabs(),
                const SizedBox(height: 16),
                const Expanded(child: LiveList()),
              ],
            ),
            const Positioned(bottom: 24, left: 0, right: 0, child: StartLiveButton()),
          ],
        ),
      ),
    );
  }
}

// 🚀 “+开启直播”悬浮按钮组件（保持原样，它是独立的）
class StartLiveButton extends StatelessWidget {
  const StartLiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleButton(
        onTap: () => context.push('/livePrepare'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8B2323),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: const Text(
            '+ 开启直播',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
