import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/routes/app_router.dart';
import '../mine_provider.dart';

// ================= 顶部个人信息头像组件 =================
class MineHeader extends StatelessWidget {
  const MineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 监听全局用户状态，确保头像、昵称、签名实时同步
    final userState = context.watch<UserStateProvider>();
    final user = userState.user;

    return InkWell(
      // 🚀 点击整个头像区域跳转至个人资料编辑子模块
      onTap: () => context.push(AppRoutes.profileEdit),
      // 去除点击水波纹背景色，保持干净
      highlightColor: Colors.transparent,
      splashColor: Colors.black.withValues(alpha: 0.02),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            // 头像部分
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5D5C5), width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'), // 预留头像占位
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // 用户文字信息部分
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
            // 🚀 加回跳转引导符号
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 16),
          ],
        ),
      ),
    );
  }
}

// ================= 配置驱动的菜单列表组件 =================
class MineMenuList extends StatelessWidget {
  const MineMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 获取当前用户是否为主播权限，用于动态过滤菜单项
    final isLive = context.select((UserStateProvider p) => p.user.role != 2);
    final provider = context.read<MineProvider>();

    // 🚀 从 MineProvider 获取过滤后的可见菜单
    final menus = provider.getVisibleMenus(isLive);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: List.generate(menus.length, (index) {
          final item = menus[index];
          final isLast = index == menus.length - 1;

          return InkWell(
            onTap: () {
              if (item.route.isNotEmpty) {
                context.push(item.route);
              } else {
                // 兜底提示
                context.showAppToast(message: "该功能即将上线，敬请期待", type: AppToastType.warning);
              }
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(index == 0 ? 16 : 0),
              bottom: Radius.circular(isLast ? 16 : 0),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1), width: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: const Color(0xFF8B2323), size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26, size: 14),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MineVipEntryCard extends StatelessWidget {
  const MineVipEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D2F24), Color(0xFF1A1512)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.vip),
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(Icons.workspace_premium, color: Color(0xFFD4AF37), size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "尊享会员",
                        style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("解锁全部精进回放", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
