import 'package:flutter/material.dart';
import 'widgets/chat_bubble.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7), // 统一米白色背景
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '系统公告',
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          SizedBox(height: 10),
          ChatBubble(messages: ['一条消息一条消息', '一条长消息一条长消息']),

          // 时间戳
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text('14:15', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),

          ChatBubble(messages: ['一条消息一条消息', '一条长消息一条长消息']),
        ],
      ),
    );
  }
}
