import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import '../mine_provider.dart';

// ================= 头部组件 =================
class MineHeader extends StatelessWidget {
  const MineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserStateProvider>();
    final user = userState.user;

    // 🚀 没有跳转逻辑时为 false，直接隐藏箭头，避免误导
    const bool canEdit = false;

    return InkWell(
      onTap: canEdit ? () => context.showAppToast(message: "去编辑资料", type: AppToastType.warning) : null,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5D5C5), width: 2),
                image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nickName.isEmpty ? '未登录' : user.nickName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4A2B2B)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.dailyQuote.isEmpty ? '静心修行，找回自我' : user.dailyQuote,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 隐藏容易引起误会的箭头
            if (canEdit) const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
          ],
        ),
      ),
    );
  }
}

// ================= 菜单组件 =================
class MineMenuList extends StatelessWidget {
  const MineMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final isAnchor = context.select((UserStateProvider p) => p.user.isAnchor);
    final menus = context.read<MineProvider>().getVisibleMenus(isAnchor);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: List.generate(menus.length, (index) {
          final item = menus[index];
          return InkWell(
            onTap: () => item.route.isNotEmpty
                ? context.push(item.route)
                : context.showAppToast(message: "功能开发中", type: AppToastType.warning),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                border: index == menus.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: const Color(0xFF8B2323), size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(item.title, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
