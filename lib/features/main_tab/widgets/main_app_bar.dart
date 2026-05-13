import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import '../main_tab_provider.dart'; // 🚀 引入大管家

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xfffdfbf7),
      title: Padding(
        padding: const EdgeInsets.only(left: 4),
        // 🚀 性能优化：使用 Selector 监听，只有标题变化时，这一个 Text 组件才会重绘！
        child: Selector<MainTabProvider, String>(
          selector: (_, p) => p.tabTitles[p.currentIndex],
          builder: (context, title, _) {
            return Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
            );
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.notice),
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.notifications_none_rounded, size: 28, color: Color(0xFF4A2B11)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
