import 'package:flutter/material.dart';
import 'package:static_touch/core/navigation/nav_service.dart';

enum AppToastType { success, error, warning }

enum AppToastPosition { top, center, bottom }

// 全局单例 Toast 记录器，防止狂点造成的 UI 叠加重影和 GPU 掉帧
OverlayEntry? _currentToastEntry;

extension AppDialogExtension on BuildContext {
  // 核心对话框 (Dialog)
  Future<bool?> showAppDialog({
    required String title,
    required String content,
    String confirmText = "确定",
    String cancelText = "取消",
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(content, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText,
                style: const TextStyle(color: Color(0xFF9E2A2B), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // 核心提示框 (Toast) - 采用 Overlay 高性能悬浮层
  void showAppToast({
    required String message,
    required AppToastType type,
    AppToastPosition position = AppToastPosition.center,
    Duration duration = const Duration(seconds: 2),
  }) {
    // 1. 匹配视觉配置
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case AppToastType.success:
        iconData = Icons.check_circle;
        iconColor = const Color(0xFF5A784A);
        bgColor = const Color(0xFFF1F4EE);
        break;
      case AppToastType.error:
        iconData = Icons.cancel;
        iconColor = const Color(0xFFA63232);
        bgColor = const Color(0xFFF8EDED);
        break;
      case AppToastType.warning:
        iconData = Icons.warning_amber;
        iconColor = const Color(0xFFDA8B33);
        bgColor = const Color(0xFFFFF8EE);
        break;
    }

    // 2. 计算位置
    Alignment alignment;
    EdgeInsets margin;

    final bottomPadding = MediaQuery.of(this).viewInsets.bottom;

    switch (position) {
      case AppToastPosition.top:
        alignment = Alignment.topCenter;
        margin = const EdgeInsets.only(top: 60);
        break;
      case AppToastPosition.center:
        alignment = Alignment.center;
        margin = EdgeInsets.zero;
        break;
      case AppToastPosition.bottom:
        alignment = Alignment.bottomCenter;
        margin = EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding + 20 : 80);
        break;
    }

    // 构建悬浮层
    final overlayState = Overlay.maybeOf(this) ?? NavService.rootNavigatorKey.currentState?.overlay;

    if (overlayState == null) return;
    // 如果当前屏幕上已经有 Toast，立刻移除它，保证永远只有一个 Toast 存在
    if (_currentToastEntry != null && _currentToastEntry!.mounted) {
      _currentToastEntry!.remove();
      _currentToastEntry = null;
    }

    _currentToastEntry = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: IgnorePointer(
            child: Align(
              alignment: alignment,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: margin,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(iconData, color: iconColor, size: 22),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(color: iconColor, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // 4. 插入屏幕并延时移除
    overlayState.insert(_currentToastEntry!);

    Future.delayed(duration, () {
      // 🚀 核心优化：只有当要移除的依然是自己时，才执行移除（防止把刚弹出的新 Toast 误删）
      if (_currentToastEntry != null && _currentToastEntry!.mounted) {
        _currentToastEntry!.remove();
        _currentToastEntry = null;
      }
    });
  }
}
