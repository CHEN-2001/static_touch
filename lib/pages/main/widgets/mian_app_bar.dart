import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;

  const MainAppBar({super.key, required this.currentIndex});

  static const List<String> _titles = ['首页', '直播', '我的', '设置'];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // 禁用自动返回按钮
      backgroundColor: const Color(0xfffdfbf7),
      title: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          _titles[currentIndex],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => context.push('/notice'),
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
