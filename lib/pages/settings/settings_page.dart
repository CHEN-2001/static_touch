import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'widgets/setting_group.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        title: const Text(
          '设置',
          style: TextStyle(color: Color(0xFF8B2323), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8B2323)),
      ),
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
                  trailing: Switch(
                    value: p.newMsgPush,
                    onChanged: p.toggleMsgPush,
                    activeColor: const Color(0xFF5B7F4B),
                  ),
                ),
                SettingItem(
                  title: '直播开始提醒',
                  trailing: Switch(
                    value: p.liveStartRemind,
                    onChanged: p.toggleLiveRemind,
                    activeColor: const Color(0xFF5B7F4B),
                  ),
                  isLast: true,
                ),
              ],
            ),

            const _SectionTitle('偏好'),
            SettingGroup(
              children: [
                SettingItem(
                  title: '自动打卡',
                  trailing: Switch(
                    value: p.autoCheckIn,
                    onChanged: p.toggleAutoCheck,
                    activeColor: const Color(0xFF5B7F4B),
                  ),
                ),
                SettingItem(
                  title: '支持后台播放',
                  trailing: Switch(
                    value: p.backgroundPlay,
                    onChanged: p.toggleBgPlay,
                    activeColor: const Color(0xFF5B7F4B),
                  ),
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
                SettingItem(
                  title: '隐私政策',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
                SettingItem(
                  title: '用户协议',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
                SettingItem(
                  title: '清除缓存',
                  trailing: const Text('10.3MB', style: TextStyle(color: Colors.grey)),
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
    child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
  );
}

class _ArrowTrailing extends StatelessWidget {
  final String text;
  const _ArrowTrailing({required this.text});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(text, style: const TextStyle(color: Colors.grey)),
      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    ],
  );
}
