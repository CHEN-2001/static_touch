import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/chat_bubble.dart';

class NoticeDetailPage extends StatelessWidget {
  // 💡 接收来自路由的参数
  final String title;
  final List<String> initialMessages;

  const NoticeDetailPage({
    super.key,
    this.title = '系统公告', // 默认标题
    this.initialMessages = const ['一条消息一条消息', '一条长消息一条长消息'],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7), // 统一米白色背景
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          // 💡 建议使用 context.pop() 适配路由
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title, // 💡 使用动态标题
          style: const TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          const SizedBox(height: 10),
          // 💡 第一组消息
          ChatBubble(messages: initialMessages),

          // 时间戳
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text('14:15', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),

          // 第二组消息（示例）
          const ChatBubble(messages: ['这里是固定展示的消息', '你可以根据业务需求从 Provider 获取更多数据']),
        ],
      ),
    );
  }
}
