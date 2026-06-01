import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/models/collection/collection_model.dart';
// 🚀 新增引入：为了转换类型
import 'package:static_touch/shared/models/live/live_item_model.dart';

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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: InkWell(
        onTap: () {
          // 🚀 核心修复：将 CollectionItem 转换为路由详情页需要的 LiveItemModel
          final liveItem = LiveItemModel(
            id: item.id,
            title: item.title,
            coverUrl: item.coverUrl,
            status: item.status,
            // 收藏列表没有的字段，给个兜底默认值，保证详情页正常渲染
            anchorName: '静心导师',
            anchorAvatar: '',
            viewerCount: 0,
            timeDisplay: item.date,
          );

          context.push('/meditationDetail', extra: liveItem);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 左侧封面图（占位）
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E7C2),
                  borderRadius: BorderRadius.circular(12),
                ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeBrown,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "时长：${item.duration}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      "收藏于：${item.date}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // 右侧状态标签
              _buildStatusTag(item.status.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(String statusStr) {
    bool isFinished = statusStr.contains('ended');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFinished
            ? const Color(0xFF8B2323).withOpacity(0.1)
            : const Color(0xFF6B8E23).withOpacity(0.1),
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
