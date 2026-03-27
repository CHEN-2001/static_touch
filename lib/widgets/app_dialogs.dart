import 'package:flutter/material.dart';

/// 提示框的业务类型
/// success: 成功（绿色系）
/// error: 失败（红色系）
/// warning: 警告（橙色系）
enum AppToastType { success, error, warning }

/// 提示框在屏幕上的显示位置
/// top: 顶部（避开刘海）
/// center: 屏幕正中（强交互反馈）
/// bottom: 底部（常用提醒，自动避开键盘）
enum AppToastPosition { top, center, bottom }

/// 全局弹窗与提示扩展
/// 通过 BuildContext 直接调用，无需手动创建实例
extension AppDialogExtension on BuildContext {
  /* -------------------------------------------------------------------------- */
  /* 核心 1：对话框 (Dialog)                                                    */
  /* -------------------------------------------------------------------------- */

  /// 显示一个标准确认对话框
  /// [title] 标题文字
  /// [content] 正文内容
  /// [confirmText] 确认按钮文字，默认“确认”
  /// [cancelText] 取消按钮文字，默认“暂缓”
  /// [confirmTextColor] 确认按钮颜色，不传则使用默认深红
  Future<bool?> showAppDialog({
    required String title,
    required String content,
    String cancelText = '暂缓',
    String confirmText = '确认',
    Color? confirmTextColor,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: false, // 强制用户操作，点击遮罩层不关闭
      builder: (context) {
        return AlertDialog(
          elevation: 0, // 去除对话框投影，配合自定义边框更高级
          // 标题样式
          title: Text(
            title,
            style: TextStyle(
              color: confirmTextColor ?? const Color(0xFF8B2323),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          // 内容样式
          content: Text(content, style: const TextStyle(color: Colors.black87, fontSize: 16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          // 底部操作按钮
          actions: [
            // 取消逻辑：返回 false
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            // 确认逻辑：返回 true
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText,
                style: TextStyle(
                  color: confirmTextColor ?? const Color(0xFF8B2323),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          // 对话框外形：圆角 + 细边框
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFF2E7C2)),
          ),
        );
      },
    );
  }

  /* -------------------------------------------------------------------------- */
  /* 核心 2：提示框 (Toast)                                                   */
  /* -------------------------------------------------------------------------- */

  /// 显示一个轻量级提示 (Toast)
  /// [message] 提示的文案
  /// [type] 提示类型（成功/失败/警告）
  /// [position] 显示位置，默认居中
  /// [duration] 持续时间，默认 2 秒
  void showAppToast({
    required String message,
    required AppToastType type,
    AppToastPosition position = AppToastPosition.center,
    Duration duration = const Duration(seconds: 2),
  }) {
    // 变量初始化
    IconData iconData;
    Color iconColor;
    Color bgColor;

    // 1. 根据传入类型匹配视觉配置
    switch (type) {
      case AppToastType.success:
        iconData = Icons.check_circle;
        iconColor = const Color(0xFF5A784A); // 成功绿
        bgColor = const Color(0xFFF1F4EE);
        break;
      case AppToastType.error:
        iconData = Icons.cancel;
        iconColor = const Color(0xFFA63232); // 错误红
        bgColor = const Color(0xFFF8EDED);
        break;
      case AppToastType.warning:
        iconData = Icons.warning_amber; // 警告橙
        iconColor = const Color(0xFFDA8B33);
        bgColor = const Color(0xFFFFF8EE);
        break;
    }

    // 2. 获取屏幕信息，计算位置常量对应的 Margin
    final screenHeight = MediaQuery.of(this).size.height;
    final viewInsetsBottom = MediaQuery.of(this).viewInsets.bottom; // 获取键盘高度

    double bottomMargin;
    // 根据枚举计算底部间距
    switch (position) {
      case AppToastPosition.top:
        bottomMargin = screenHeight * 0.8; // 靠近顶部
        break;
      case AppToastPosition.center:
        bottomMargin = screenHeight * 0.5; // 正中心
        break;
      case AppToastPosition.bottom:
        // 如果有键盘，浮在键盘上方 20px；没键盘，固定离底 60px
        bottomMargin = viewInsetsBottom > 0 ? viewInsetsBottom + 20 : 60;
        break;
    }

    // 3. 移除当前正在显示的 SnackBar，避免堆叠延迟
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    // 4. 构建并显示 SnackBar 模拟的胶囊 Toast
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        elevation: 0, // 🚀 关键：去除阴影
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 内部内容水平居中
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(color: iconColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating, // 设置为浮动模式才能调整 margin
        duration: duration,
        margin: EdgeInsets.only(bottom: bottomMargin, left: 50, right: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 胶囊圆角
          side: BorderSide(color: iconColor.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
