import 'package:static_touch/enum/live_status_enum.dart';

class CollectionItem {
  final String id;
  final String title;
  final String coverUrl;
  final String duration;
  final String date;
  final LiveStatusEnum status; // 收藏的一般是“已结束”的回放或“未开始”的预约

  CollectionItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.duration,
    required this.date,
    required this.status,
  });
}
