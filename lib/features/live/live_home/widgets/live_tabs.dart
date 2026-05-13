import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_provider.dart';

class LiveTabs extends StatelessWidget {
  const LiveTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.read<LiveProvider>();
    const activeColor = Color(0xFF8B2323);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(p.tabs.length, (index) {
          return Selector<LiveProvider, bool>(
            selector: (_, provider) => provider.currentTabIndex == index,
            builder: (context, isSelected, _) {
              return GestureDetector(
                onTap: () => p.setTabIndex(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.tabs[index],
                        style: TextStyle(
                          color: isSelected ? activeColor : Colors.grey,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Opacity(
                        opacity: isSelected ? 1 : 0,
                        child: Container(
                          height: 2,
                          width: 20,
                          color: activeColor,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
