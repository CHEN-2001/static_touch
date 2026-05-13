import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'settings_provider.dart';
import 'widgets/setting_group.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('消息与提醒'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '新消息推送',
                  trailing: AppAnimSwitch(value: p.newMsgPush, onChanged: p.toggleMsgPush),
                ),
                SettingItem(
                  title: '直播开始提醒',
                  trailing: AppAnimSwitch(value: p.liveStartRemind, onChanged: p.toggleLiveRemind),
                  isLast: true,
                ),
              ],
            ),

            const _SectionTitle('偏好'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '自动打卡',
                  trailing: AppAnimSwitch(value: p.autoCheckIn, onChanged: p.toggleAutoCheck),
                ),
                SettingItem(
                  title: '支持后台播放',
                  trailing: AppAnimSwitch(value: p.backgroundPlay, onChanged: p.toggleBgPlay),
                ),
                SettingItem(
                  title: '音质设置',
                  trailing: const _ArrowTrailing(text: '无损'),
                  isLast: true,
                ),
              ],
            ),

            const _SectionTitle('隐私与关于'),
            SettingGroup(
              children: [
                const SettingItem(
                  title: '隐私政策',
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
                const SettingItem(
                  title: '用户协议',
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
                const SettingItem(
                  title: '清除缓存',
                  trailing: Text('10.3MB', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ✅ 退出登录按钮
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8B2323), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _handleLogout(context),
                child: const Text(
                  '退出登录',
                  style: TextStyle(color: Color(0xFF8B2323), fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ✅ 退出登录逻辑
  Future<void> _handleLogout(BuildContext context) async {
    bool? confirm = await context.showAppDialog(title: '退出登录', content: '确定要退出当前账号吗？数据将停止同步。', confirmText: '退出');

    if (confirm == true) {
      await TokenManager.clearToken();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}

// ==================== 自定义组件 ====================

class AppAnimSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppAnimSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? const Color(0xFF4F7942) : const Color(0xFFD8D8D8),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }
}

class _ArrowTrailing extends StatelessWidget {
  final String text;
  const _ArrowTrailing({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ],
    );
  }
}
