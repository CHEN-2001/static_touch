import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final List<String> messages;

  const ChatBubble({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧灰色头像占位
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFEFEBE4),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // 消息气泡组
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messages
                  .map(
                    (msg) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E9EF), // 气泡灰色背景
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(msg, style: const TextStyle(color: Color(0xFF333333), fontSize: 15)),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(width: 40), // 右侧留空，模拟聊天对齐
        ],
      ),
    );
  }
}
