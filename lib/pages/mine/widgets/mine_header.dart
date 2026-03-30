import 'package:flutter/material.dart';

class MineHeader extends StatelessWidget {
  const MineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '我的',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // 圆形头像
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '用户名',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3D2B1F)),
        ),
      ],
    );
  }
}
