import 'package:flutter/material.dart';

enum LiveStatus {
  upcoming(2, "未开始", Color(0xFFDAA520)),
  ongoing(1, "直播中", Color(0xFF6B8E23)),
  finished(0, "已结束", Color(0xFFD3D3D3));

  final int value;
  final String tag;
  final Color color;

  const LiveStatus(this.value, this.tag, this.color);

  static LiveStatus fromInt(int value) {
    return LiveStatus.values.firstWhere((e) => e.value == value, orElse: () => LiveStatus.upcoming);
  }
}
