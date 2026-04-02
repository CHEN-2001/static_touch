import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'live_provider.dart';
import 'widgets/live_player.dart';
import 'widgets/live_actions.dart';
import 'widgets/live_chat_list.dart';

class LiveDetailPage extends StatefulWidget {
  const LiveDetailPage({super.key});

  @override
  State<LiveDetailPage> createState() => _LiveDetailPageState();
}

class _LiveDetailPageState extends State<LiveDetailPage> {
  // 🚀 核心：用于控制输入框内容的控制器
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 🚀 发送逻辑
  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      // 调用之前修复好的 LiveProvider 里的 sendDanmu 方法
      context.read<LiveProvider>().sendDanmu(text);
      _inputController.clear(); // 清空输入框
      _focusNode.unfocus(); // 发送后收起键盘（可选，根据用户习惯）
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      // 🚀 关键：防止键盘弹出时挤压 UI 导致布局报错
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopBar(context),

            // 视频播放区
            const LivePlayer(),

            // 收藏/打赏栏
            const LiveActions(),

            // 聊天区域（Expanded 占据剩余空间）
            const Expanded(child: LiveChatList()),

            // 🚀 真正的输入栏
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        // 🚀 关键：适配 iOS/Android 的底部安全区和键盘高度
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: const Color(0xFFD4AF37), // 金色光标
                decoration: const InputDecoration(
                  hintText: '说点什么...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                // 点击键盘上的“发送/完成”也会触发
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Text(
                '发送',
                style: TextStyle(
                  color: Color(0xFFD4AF37), // 禅意金色
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
