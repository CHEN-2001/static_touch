import 'package:flutter/material.dart';

class NfcActionList extends StatelessWidget {
  const NfcActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _row(
            '查看绑定答案',
            trail: const Text('重新绑定 >', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          _row(
            '音饰保养说明',
            trail: const Text('了解详情 >', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          _row('解除设备绑定', trail: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), isLast: true),
        ],
      ),
    );
  }

  Widget _row(String title, {required Widget trail, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
          trail,
        ],
      ),
    );
  }
}
