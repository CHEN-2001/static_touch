import 'package:flutter/material.dart';
import 'widgets/live_player.dart';
import 'widgets/live_actions.dart';
import 'widgets/live_chat_list.dart';

class LiveDetailPage extends StatelessWidget {
  const LiveDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // 沉浸式深色背景
      body: SafeArea(
        child: Column(
          children: [
            // 顶部关闭按钮区域
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const LivePlayer(), // 视频播放区
            const LiveActions(), // 收藏/打赏栏
            const Expanded(child: LiveChatList()), // 聊天区域
            // 底部输入框占位
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
              child: const Text('说点什么...', style: TextStyle(color: Colors.white54, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '发送',
            style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
