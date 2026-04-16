import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'notice_provider.dart';
import 'widgets/notice_item.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NoticeProvider>();
    final tabs = ['全部', '公告', '提醒'];

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 18),
          onPressed: () => context.pop(), // 使用 go_router 的 pop
        ),
        centerTitle: true,
        title: const Text(
          '消息通知',
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: p.markAllAsRead,
            child: const Text('一键已读', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
      body: Column(
        children: [
          // 自定义 TabBar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                bool isSelected = p.currentTabIndex == index;
                return GestureDetector(
                  onTap: () => p.setTabIndex(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF8B2323) : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2,
                        width: isSelected ? 20 : 0,
                        color: const Color(0xFF8B2323),
                        margin: const EdgeInsets.only(top: 4),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1, color: Color(0x1A000000)),
          // 消息列表
          Expanded(
            child: ListView(
              children: [
                NoticeItem(
                  type: '系统',
                  title: '系统公告',
                  content: '点击查看详细公告内容',
                  time: '14:15',
                  hasDot: true,
                  onTap: () {
                    context.push(
                      '/noticeDetail',
                      extra: {
                        'title': '系统公告',
                        'messages': ['感谢关注静触 App！', '这是通过路由传过来的第一条详情消息。'],
                      },
                    );
                  },
                ),
                NoticeItem(
                  type: '系统',
                  title: '系统公告',
                  content: '点击查看详细公告内容',
                  time: '14:15',
                  hasDot: true,
                  onTap: () {
                    context.push(
                      '/noticeDetail',
                      extra: {
                        'title': '系统公告',
                        'messages': ['感谢关注静触 App！', '这是通过路由传过来的第一条详情消息。'],
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
