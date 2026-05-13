import 'package:flutter/material.dart';

// ================= 基础容器组 =================
class SettingGroup extends StatelessWidget {
  final List<Widget> children;
  const SettingGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final Widget trailing;
  final bool isLast;
  final VoidCallback? onTap; // 🚀 新增点击事件支持

  const SettingItem({
    super.key,
    required this.title,
    required this.trailing,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
          trailing,
        ],
      ),
    );

    // 如果传入了 onTap，则包裹 InkWell 增加点击水波纹
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : BorderRadius.zero,
        child: child,
      );
    }
    return child;
  }
}

// ================= 专属 UI 组件 =================
class SettingSectionTitle extends StatelessWidget {
  final String title;
  const SettingSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingArrowTrailing extends StatelessWidget {
  final String? text;
  const SettingArrowTrailing({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (text != null) ...[
          Text(text!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 6),
        ],
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ],
    );
  }
}

// 🚀 自定义丝滑开关
class AppAnimSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppAnimSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? const Color(0xFF4F7942) : const Color(0xFFD8D8D8),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
