import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/collection_model.dart';

class CollectionItemTile extends StatelessWidget {
  final CollectionItem item;
  const CollectionItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const themeBrown = Color(0xFF4A2B11);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: InkWell(
        onTap: () => context.push(
          '/meditationDetail',
          extra: {'title': item.title, 'status': item.status, 'startTime': DateTime.now()},
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 左侧封面图（占位）
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: const Color(0xFFF2E7C2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.spa, color: Color(0xFFD4AF37)),
              ),
              const SizedBox(width: 16),
              // 中间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: themeBrown, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text("时长：${item.duration}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text("收藏于：${item.date}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              // 右侧状态标签
              _buildStatusTag(item.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(status) {
    bool isFinished = status.toString().contains('finished');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFinished ? const Color(0xFF8B2323).withOpacity(0.1) : const Color(0xFF6B8E23).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isFinished ? "回放" : "预告",
        style: TextStyle(
          color: isFinished ? const Color(0xFF8B2323) : const Color(0xFF6B8E23),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
