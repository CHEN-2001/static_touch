import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/notice_widgets.dart'; // 🚀 统一引入新的聚合组件库

class NoticeDetailPage extends StatelessWidget {
  final String title;
  final List<String> initialMessages;

  const NoticeDetailPage({
    super.key,
    this.title = '系统公告',
    this.initialMessages = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF4A2B11),
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF4A2B11),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          const SizedBox(height: 10),
          ChatBubble(messages: initialMessages),

          // 如果需要加上时间戳，可以扩展传入参数，此处使用固定占位示范
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                '刚刚',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
