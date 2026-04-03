import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // 阴影保持在 Container 上
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      // 💡 核心点 1：使用 ClipRRect 强行裁剪内部所有子组件的溢出
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent, // 设置为透明，使用父容器的白色
          child: Column(
            children: [
              _item(
                context,
                '我的收藏',
                const Icon(Icons.arrow_forward, size: 18),
                isLast: false,
                onTap: () => context.push('/collections'),
              ),
              _item(
                context,
                '我的NFC',
                const Text('查看', style: TextStyle(color: Colors.grey)),
                onTap: () => context.push('/nfc'),
              ),
              _item(
                context,
                '修行数据',
                const Text('查看', style: TextStyle(color: Colors.grey)),
                onTap: () => context.push('/stats'),
              ),
              _item(context, '帮助中心', const Icon(Icons.arrow_forward, size: 18), onTap: () => print('点击了帮助')),
              _item(
                context,
                '直播数据',
                const Icon(Icons.arrow_forward, size: 18),
                isLast: true,
                onTap: () => context.push('/liveDataProvider'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String title, Widget trail, {bool isLast = false, VoidCallback? onTap}) {
    // 💡 核心点 2：InkWell 必须在 Material 内部
    return InkWell(
      onTap: onTap,
      // 你也可以在这里指定 splashColor: Colors.black12 来让按下的效果更高级
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        // 这里的 decoration 只负责底部的分割线
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
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
