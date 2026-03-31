import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nfc_provider.dart';
import 'widgets/nfc_header_card.dart';
import 'widgets/nfc_action_list.dart';

class NfcPage extends StatelessWidget {
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '我的NFC',
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const NfcHeaderCard(), // 顶部展示卡片
          const SizedBox(height: 20),
          const NfcActionList(), // 功能菜单
          const Spacer(), // 将按钮推到底部
          // 底部一键进入按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => context.read<NfcProvider>().enterLive(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B2323),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  '一键进入直播',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text('绑定音饰后，触碰感应位即可快速修行', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
