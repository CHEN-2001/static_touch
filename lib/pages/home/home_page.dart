import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/pages/home/widgets/home_header.dart';
import 'package:static_touch/pages/home/widgets/duration_card.dart';
import 'package:static_touch/pages/home/widgets/schedule_list.dart';
import 'package:static_touch/providers/user_state_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStateProvider>().initData();
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [HomeHeader(), SizedBox(height: 30), DurationCard(), SizedBox(height: 30)],
            ),
          ),
          const SliverToBoxAdapter(child: ScheduleList()),
        ],
      ),
    );
  }
}
