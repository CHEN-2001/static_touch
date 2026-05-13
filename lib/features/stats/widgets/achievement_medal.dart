import 'package:flutter/material.dart';

class AchievementMedal extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isUnlocked;

  const AchievementMedal({super.key, required this.label, this.icon, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    const Color medalColor = Color(0xFFD4AF37); // 禅意金

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? Colors.transparent : const Color(0xFFF5F5F5), // 未解锁加灰底
            border: Border.all(color: medalColor.withOpacity(0.5), width: 2),
          ),
          child: isUnlocked
              ? Icon(icon ?? Icons.workspace_premium, color: medalColor, size: 30)
              : const Center(
                  child: Text(
                    '未解\n锁',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
