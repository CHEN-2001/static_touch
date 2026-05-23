import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'widgets/live_tabs.dart';
import 'widgets/live_list.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isLive = context.select((UserStateProvider p) => p.user.role != 2);

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: const SafeArea(
        child: Column(
          children: [
            LiveTabs(),
            SizedBox(height: 16),
            Expanded(child: LiveList()),
          ],
        ),
      ),
      floatingActionButton: isLive
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.livePrepare),
              backgroundColor: const Color(0xFF8B2323),
              icon: const Icon(Icons.video_call, color: Colors.white),
              label: const Text('开启直播', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }
}
