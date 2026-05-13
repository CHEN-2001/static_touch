import 'package:flutter/material.dart';

// 🚀 1. 纯净的核心业务状态 (对接后端)
enum LiveStatus {
  preparing(0), // 准备中
  live(1), // 直播中
  ended(2); // 已结束

  final int code;
  const LiveStatus(this.code);

  static LiveStatus fromCode(int? code) {
    return LiveStatus.values.firstWhere((e) => e.code == code, orElse: () => LiveStatus.ended);
  }
}

// 🚀 2. UI 渲染扩展 (将颜色和文字抽离到这里，UI 层直接调用 item.status.color)
extension LiveStatusUIX on LiveStatus {
  String get tag {
    switch (this) {
      case LiveStatus.preparing:
        return '准备中';
      case LiveStatus.live:
        return '直播中';
      case LiveStatus.ended:
        return '已结束';
    }
  }

  Color get color {
    switch (this) {
      case LiveStatus.preparing:
        return const Color(0xFFD4AF37); // 禅意金
      case LiveStatus.live:
        return const Color(0xFF9E2A2B); // 主题红
      case LiveStatus.ended:
        return Colors.grey;
    }
  }
}
