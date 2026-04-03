import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // 🚀 1. 导入路由插件
import 'nfc_provider.dart';
import 'widgets/nfc_header_card.dart';
import 'widgets/nfc_action_list.dart';

class NfcPage extends StatelessWidget {
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 定义统一的主题色，建议后续抽离到常量文件
    const Color themeBrown = Color(0xFF4A2B11);
    const Color themeRed = Color(0xFF8B2323);
    const Color themeBg = Color(0xFFFDFBF7);

    return Scaffold(
      backgroundColor: themeBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: themeBrown, size: 20),
          onPressed: () => context.pop(), // 使用 go_router 的 pop
        ),
        title: const Text(
          '我的NFC',
          style: TextStyle(color: themeBrown, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. 顶部展示卡片（内含 NFC 芯片状态展示）
          const NfcHeaderCard(),

          const SizedBox(height: 20),

          // 2. 功能菜单（如：写入芯片、格式化、读取测试等）
          const NfcActionList(),

          const Spacer(), // 自动撑开中间空白，将按钮推到底部
          // 3. 底部一键进入按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // 🚀 执行 NFC 业务逻辑（如校验、日志记录）
                  context.read<NfcProvider>().enterLive();

                  // 🚀 执行路由跳转，进入直播详情页
                  context.push('/liveDetailPage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeRed,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: themeRed.withOpacity(0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  '一键进入直播',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2, // 增加字间距，提升视觉质感
                  ),
                ),
              ),
            ),
          ),

          // 4. 底部提示语
          const Padding(
            padding: EdgeInsets.only(bottom: 30, top: 8),
            child: Text(
              '绑定音饰后，触碰感应位即可快速修行',
              style: TextStyle(color: Color(0xFF999999), fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
