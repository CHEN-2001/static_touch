import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _item('我的收藏', const Icon(Icons.arrow_forward, size: 18)),
          _item('我的NFC', const Text('查看', style: TextStyle(color: Colors.grey))),
          _item('修行数据', const Text('查看', style: TextStyle(color: Colors.grey))),
          _item('帮助中心', const Icon(Icons.arrow_forward, size: 18)),
          _item('直播数据', const Icon(Icons.arrow_forward, size: 18), isLast: true),
        ],
      ),
    );
  }

  Widget _item(String title, Widget trail, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF3D2B1F))),
          trail,
        ],
      ),
    );
  }
}
