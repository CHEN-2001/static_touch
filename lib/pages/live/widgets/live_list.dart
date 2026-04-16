import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/pages/live/live_provider.dart';
import 'package:static_touch/enum/live_status_enum.dart';
import 'package:static_touch/models/live/live_item_model.dart';

class LiveList extends StatelessWidget {
  const LiveList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select((LiveProvider liveProvider) => liveProvider.filteredLives);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) => LiveCardItem(item: items[index]),
    );
  }
}

// 卡片组件
class LiveCardItem extends StatelessWidget {
  final LiveItemModel item;
  const LiveCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          if (item.status == LiveStatusEnum.ongoing) {
            context.push('/liveDetailPage');
          } else {
            context.push('/meditationDetail', extra: item);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(color: Colors.black87),
              Positioned(top: 12, left: 12, child: _buildStatusTag(item.status)),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  '《${item.title}》',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 状态标签局部 Widget（支持 const 优化）
  Widget _buildStatusTag(LiveStatusEnum status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: status.color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.tag,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
