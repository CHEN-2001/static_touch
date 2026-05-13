import 'package:flutter/material.dart';

class NoticeItem extends StatelessWidget {
  final String type;
  final String title;
  final String content;
  final String time;
  final bool hasDot;
  final VoidCallback? onTap;

  const NoticeItem({
    super.key,
    required this.type,
    required this.title,
    required this.content,
    required this.time,
    this.hasDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 类型图标
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: type == '系统'
                      ? const Color(0xFF8B2323).withOpacity(0.1)
                      : const Color(0xFFD4AF37).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  type == '系统' ? Icons.campaign_rounded : Icons.notifications_active_rounded,
                  color: type == '系统' ? const Color(0xFF8B2323) : const Color(0xFFD4AF37),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // 文字内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF3D2B1F)),
                        ),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.brown.withValues(alpha: 0.7), fontSize: 13),
                    ),
                  ],
                ),
              ),
              // 未读红点
              if (hasDot)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Color(0xFF8B2323), shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
