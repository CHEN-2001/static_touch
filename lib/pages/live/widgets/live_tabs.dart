import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_provider.dart';

class LiveTabs extends StatelessWidget {
  const LiveTabs({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 大厂标准：数据源通常是写死的配置
    final tabs = const ['全部', '直播中', '即将开始', '已结束'];
    final currentIndex = context.select((LiveProvider p) => p.currentTabIndex);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        // 💡 均匀排布 Tab
        children: List.generate(tabs.length, (index) {
          bool isSelected = currentIndex == index;
          Color color = isSelected ? const Color(0xFF8B2323) : Colors.grey;

          return GestureDetector(
            onTap: () => context.read<LiveProvider>().setTabIndex(index),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isSelected) // 下划线指示器
                    Container(
                      height: 2,
                      width: 20,
                      color: const Color(0xFF8B2323),
                      margin: const EdgeInsets.only(top: 4),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
