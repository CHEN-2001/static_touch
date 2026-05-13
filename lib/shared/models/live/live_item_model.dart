import 'package:static_touch/shared/enum/live_status_enum.dart';

class LiveItemModel {
  final String id;
  final String title;
  final String coverUrl;
  final String anchorName;
  final String anchorAvatar;
  final int viewerCount;
  final LiveStatus status; // 💡 使用规范的新枚举名
  final String timeDisplay;
  final String? streamUrl;

  LiveItemModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.anchorName,
    required this.anchorAvatar,
    required this.viewerCount,
    required this.status,
    required this.timeDisplay,
    this.streamUrl,
  });

  factory LiveItemModel.fromJson(Map<String, dynamic> json) {
    return LiveItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '未命名直播',
      coverUrl: json['coverUrl'] ?? 'https://via.placeholder.com/400x300',
      anchorName: json['anchorName'] ?? '静心导师',
      anchorAvatar: json['anchorAvatar'] ?? '',
      viewerCount: json['viewerCount'] ?? 0,
      status: LiveStatus.fromCode(json['statusCode']),
      timeDisplay: json['timeDisplay'] ?? '10:00 - 11:00',
      streamUrl: json['streamUrl'],
    );
  }
}
