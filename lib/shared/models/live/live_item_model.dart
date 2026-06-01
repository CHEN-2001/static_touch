import 'package:static_touch/shared/enum/live_status_enum.dart';

class LiveItemModel {
  final String id;
  final String title;
  final String coverUrl;
  final String anchorName;
  final String anchorAvatar;
  final int viewerCount;
  final LiveStatus status;
  final String timeDisplay;

  LiveItemModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.anchorName,
    required this.anchorAvatar,
    required this.viewerCount,
    required this.status,
    required this.timeDisplay,
  });

  factory LiveItemModel.fromJson(Map<String, dynamic> json) {
    // 格式化 expectedStartTime
    String timeDisplay = '';
    final expectedStartTime = json['expectedStartTime'];
    if (expectedStartTime != null && expectedStartTime is String && expectedStartTime.isNotEmpty) {
      timeDisplay = _formatTimeToHourMinute(expectedStartTime);
    } else {
      timeDisplay = '时间待定';
    }

    return LiveItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '未命名直播',
      coverUrl: json['coverUrl'] ?? '',
      anchorName: json['nickname'] ?? '用户',
      anchorAvatar: json['avatarUrl'] ?? '',
      viewerCount: json['onlineCount'] ?? 0,
      status: LiveStatus.fromCode(json['status'] ?? 0),
      timeDisplay: timeDisplay,
    );
  }

  static String _formatTimeToHourMinute(String isoString) {
    try {
      final timePart = isoString.split('T').last;
      if (timePart.length >= 5) {
        return timePart.substring(0, 5);
      }
      return timePart;
    } catch (e) {
      return '时间待定';
    }
  }
}
