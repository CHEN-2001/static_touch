import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/duration_card.dart';
import 'widgets/schedule_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}
