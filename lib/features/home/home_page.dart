import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/features/home/widgets/home_header.dart';
import 'package:static_touch/features/home/widgets/duration_card.dart';
import 'package:static_touch/features/home/widgets/schedule_list.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🚀 首次进入加载
      context.read<UserStateProvider>().initData(isSilent: false);
      context.read<LiveStateProvider>().initAndRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // 🚀 核心重构：从 ScrollView 换成 Column，让上半部分彻底固定！
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 20),
          HomeHeader(),
          SizedBox(height: 30),
          DurationCard(),
          SizedBox(height: 30),
          // 🚀 核心重构：将屏幕剩余的所有空间，交给下方的时刻表列表！
          Expanded(child: ScheduleList()),
        ],
      ),
    );
  }
}
