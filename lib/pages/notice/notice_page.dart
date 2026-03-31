import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '消息通知',
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
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
                  child: Column(
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF8B2323) : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          height: 2,
                          width: 20,
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
              children: const [
                NoticeItem(type: '系统', title: '系统公告', content: '系统公告通知设置，系统公告通知设置', time: '10:00', hasDot: true),
                NoticeItem(type: '提醒', title: '修行提醒', content: '系统公告通知设置，系统公告通知设置', time: '8:00'),
                NoticeItem(type: '提醒', title: '开播提醒', content: '你订阅的xxxx开播了，快去观看吧！', time: '8:00', hasDot: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
