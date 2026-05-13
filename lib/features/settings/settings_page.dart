import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'settings_provider.dart';
import 'widgets/settings_widgets.dart'; // 🚀 引入大一统组件库

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
            const SettingSectionTitle('消息与提醒'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '新消息推送',
                  trailing: AppAnimSwitch(
                    value: p.newMsgPush,
                    onChanged: p.toggleMsgPush,
                  ),
                ),
                SettingItem(
                  title: '直播开始提醒',
                  trailing: AppAnimSwitch(
                    value: p.liveStartRemind,
                    onChanged: p.toggleLiveRemind,
                  ),
                  isLast: true,
                ),
              ],
            ),

            const SettingSectionTitle('偏好'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '自动打卡',
                  trailing: AppAnimSwitch(
                    value: p.autoCheckIn,
                    onChanged: p.toggleAutoCheck,
                  ),
                ),
                SettingItem(
                  title: '支持后台播放',
                  trailing: AppAnimSwitch(
                    value: p.backgroundPlay,
                    onChanged: p.toggleBgPlay,
                  ),
                ),
                SettingItem(
                  title: '音质设置',
                  trailing: const SettingArrowTrailing(text: '无损'),
                  isLast: true,
                  onTap: () => context.showAppToast(
                    message: "音质切换即将上线",
                    type: AppToastType.warning,
                  ),
                ),
              ],
            ),

            const SettingSectionTitle('隐私与关于'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '隐私政策',
                  trailing: const SettingArrowTrailing(),
                  onTap: () {}, // 预留路由跳转
                ),
                SettingItem(
                  title: '用户协议',
                  trailing: const SettingArrowTrailing(),
                  onTap: () {}, // 预留路由跳转
                ),
                SettingItem(
                  title: '清除缓存',
                  trailing: const Text(
                    '10.3MB',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  isLast: true,
                  onTap: () {
                    // 增加交互反馈
                    context.showAppToast(
                      message: "缓存清理成功",
                      type: AppToastType.success,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 🚀 退出登录按钮 (接入 Loading 状态)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8B2323), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: p.isLoading ? null : () => _handleLogout(context, p),
                child: p.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF8B2323),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '退出登录',
                        style: TextStyle(
                          color: Color(0xFF8B2323),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ================= 路由与弹窗交互逻辑 =================
  Future<void> _handleLogout(BuildContext context, SettingsProvider p) async {
    bool? confirm = await context.showAppDialog(
      title: '退出登录',
      content: '确定要退出当前账号吗？数据将停止同步。',
      confirmText: '退出',
    );

    if (confirm == true) {
      final success = await p.logout();
      if (success && context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
