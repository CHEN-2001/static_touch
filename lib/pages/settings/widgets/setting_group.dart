import 'package:flutter/material.dart';

class SettingGroup extends StatelessWidget {
  final List<Widget> children;
  const SettingGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final Widget trailing;
  final bool isLast;

  const SettingItem({super.key, required this.title, required this.trailing, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
          trailing,
        ],
      ),
    );
  }
}
