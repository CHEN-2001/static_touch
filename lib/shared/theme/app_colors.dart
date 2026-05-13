import 'package:flutter/material.dart';

/// 全局色彩规范
class AppColors {
  // 主色调
  static const Color primary = Color(0xFF9E2A2B); // 主题深红
  static const Color zenRed = Color(0xFF8B2323); // 禅意红 (如按钮、高亮文字)
  static const Color zenGold = Color(0xFFD4AF37); // 禅意金 (如重点标识、金牌)

  // 背景与基础色
  static const Color background = Color(0xFFFDFBF7); // 统一的米白背景色
  static const Color surface = Colors.white; // 卡片/弹窗背景
  static const Color cardBorder = Color(0xFFF2E7C2); // 卡片边框色

  // 文本色
  static const Color textPrimary = Color(0xFF333333); // 主标题文本
  static const Color textSecondary = Color(0xFF4A2B11); // 次级棕色文本
  static const Color textTertiary = Colors.grey; // 辅助灰色文本
}
