import 'package:flutter/material.dart';
import 'package:static_touch/core/navigation/nav_service.dart';

// 🚀 1. 补齐 info 枚举
enum AppToastType { success, error, warning, info }

enum AppToastPosition { top, center, bottom }

OverlayEntry? _currentToastEntry;

extension AppDialogExtension on BuildContext {
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

  void showAppToast({
    required String message,
    required AppToastType type,
    AppToastPosition position = AppToastPosition.center,
    Duration duration = const Duration(seconds: 2),
  }) {
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
      // 补齐 info 的视觉配置（静谧蓝灰色）
      case AppToastType.info:
        iconData = Icons.info_outline;
        iconColor = const Color(0xFF5B7A8C);
        bgColor = const Color(0xFFF0F4F8);
        break;
    }

    Alignment alignment;
    EdgeInsets margin;
    final bottomPadding = MediaQuery.maybeOf(this)?.viewInsets.bottom ?? 0.0;
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

    final overlayState = Overlay.maybeOf(this) ?? NavService.rootNavigatorKey.currentState?.overlay;
    if (overlayState == null) return;

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
                    // 规范替换为 withValues(alpha: x)
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

    overlayState.insert(_currentToastEntry!);

    Future.delayed(duration, () {
      if (_currentToastEntry != null && _currentToastEntry!.mounted) {
        _currentToastEntry!.remove();
        _currentToastEntry = null;
      }
    });
  }
}
