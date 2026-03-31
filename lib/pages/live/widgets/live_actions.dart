import 'package:flutter/material.dart';

class LiveActions extends StatelessWidget {
  const LiveActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // 保持和背景一致
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        children: [
          // 1. 左侧功能文字组
          _buildTextBtn('关闭视频', () => Navigator.pop(context)),
          const SizedBox(width: 20),
          _buildTextBtn('自吸音', () => print('触发自吸音')),
          const SizedBox(width: 20),
          _buildTextBtn('收藏', () => print('触发收藏')),

          const Spacer(), // 撑开中间距离
          // 2. 右侧打赏按钮
          GestureDetector(
            onTap: () => print('触发打赏'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8B2323), // 红褐色背景
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '给心打赏',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 抽离通用文字按钮
  Widget _buildTextBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFEFEBE4), // 浅米色文字
          fontSize: 14,
        ),
      ),
    );
  }
}
