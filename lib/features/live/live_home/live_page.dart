import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'widgets/live_tabs.dart';
import 'widgets/live_list.dart';
import 'widgets/live_start_action_widget.dart';
import 'package:static_touch/features/live/live_home/live_provider.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveProvider>().fetchTodaySchedule();
    });
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLive ? const LiveStartActionWidget() : null,
    );
  }
}
