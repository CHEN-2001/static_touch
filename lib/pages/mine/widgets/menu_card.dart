import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. 定义一个简单的配置类，让代码更清晰
class MenuItemConfig {
  final String title;
  final Widget trail;
  final String? route;
  final VoidCallback? onTap;

  MenuItemConfig({required this.title, required this.trail, this.route, this.onTap});
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. 数据驱动：集中管理菜单项，以后增删改查只需要动这个 List
    final List<MenuItemConfig> menuItems = [
      MenuItemConfig(title: '我的收藏', trail: const Icon(Icons.arrow_forward, size: 18), route: '/collections'),
      MenuItemConfig(
        title: '我的NFC',
        trail: const Text('查看', style: TextStyle(color: Colors.grey)),
        route: '/nfc',
      ),
      MenuItemConfig(
        title: '修行数据',
        trail: const Text('查看', style: TextStyle(color: Colors.grey)),
        route: '/stats',
      ),
      MenuItemConfig(title: '帮助中心', trail: const Icon(Icons.arrow_forward, size: 18), onTap: () => debugPrint('点击了帮助')),
      MenuItemConfig(title: '直播数据', trail: const Icon(Icons.arrow_forward, size: 18), route: '/liveDataProvider'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: Column(
            // 3. 自动遍历生成，并自动判断是否是最后一项
            children: menuItems.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              return _MenuItem(
                title: data.title,
                trail: data.trail,
                isLast: index == menuItems.length - 1, // 自动判断
                onTap: data.onTap ?? () => context.push(data.route!),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// 4. 将 item 抽离成独立的 Widget 提高渲染性能
class _MenuItem extends StatelessWidget {
  final String title;
  final Widget trail;
  final bool isLast;
  final VoidCallback onTap;
  const _MenuItem({required this.title, required this.trail, required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.black.withValues(alpha: 0.03),
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0x0D000000))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF3D2B1F))),
            trail,
          ],
        ),
      ),
    );
  }
}
