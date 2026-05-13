import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
// 🚀 核心修正：引入 shared 下的正规模型
import 'package:static_touch/shared/models/notice/notice_model.dart';
import '../notice_provider.dart';

// ================= 顶部动态 Tab 组件 =================
class NoticeTabs extends StatelessWidget {
  const NoticeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NoticeProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(p.tabs.length, (index) {
          final isSelected = p.currentTabIndex == index;
          return GestureDetector(
            onTap: () => p.setTabIndex(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Text(
                  p.tabs[index],
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF8B2323) : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
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
    );
  }
}

// ================= 消息列表 Item 组件 =================
class NoticeItemTile extends StatelessWidget {
  final NoticeModel notice;

  const NoticeItemTile({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final isSystem = notice.type == '系统';
    final mainColor = isSystem
        ? const Color(0xFF8B2323)
        : const Color(0xFFD4AF37);

    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.noticeDetail,
          extra: {'title': notice.title, 'messages': notice.messages},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSystem
                    ? Icons.campaign_rounded
                    : Icons.notifications_active_rounded,
                color: mainColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notice.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF3D2B1F),
                        ),
                      ),
                      Text(
                        notice.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notice.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.brown.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!notice.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B2323),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================= 详情页聊天气泡组件 =================
class ChatBubble extends StatelessWidget {
  final List<String> messages;
  const ChatBubble({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFEFEBE4),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messages
                  .map(
                    (msg) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E9EF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        msg,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
