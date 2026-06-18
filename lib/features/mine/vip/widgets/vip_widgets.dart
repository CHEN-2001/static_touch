import 'package:flutter/material.dart';
import 'package:static_touch/shared/models/vip/vip_model.dart';
import 'package:static_touch/shared/models/user/user_model.dart';

// ================= 1. 会员状态卡片 =================
class VipHeaderCard extends StatelessWidget {
  final UserModel user;
  final VipStatusModel? status;

  const VipHeaderCard({super.key, required this.user, this.status});

  @override
  Widget build(BuildContext context) {
    final isVip = status?.isVip ?? false;
    final expireText = status?.expireDate ?? '';

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isVip
              ? [const Color(0xFFF1DCA1), const Color(0xFFD4AF37)]
              : [const Color(0xFF4A4A4A), const Color(0xFF2C2C2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: user.avatarUrl.isNotEmpty
                ? NetworkImage(user.avatarUrl)
                : const AssetImage('assets/images/logo.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.nickName.isEmpty ? '静触行者' : user.nickName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isVip ? const Color(0xFF4A2B11) : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isVip) const Icon(Icons.workspace_premium, color: Color(0xFF8B2323), size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  expireText,
                  style: TextStyle(
                    color: isVip ? const Color(0xFF4A2B11).withOpacity(0.7) : Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 2. 套餐选项卡 =================
class VipPlanCard extends StatelessWidget {
  final VipPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const VipPlanCard({super.key, required this.plan, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? goldColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? goldColor : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            Text(
              plan.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF4A2B11) : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('¥', style: TextStyle(fontSize: 14, color: isSelected ? goldColor : Colors.black87)),
                Text(
                  plan.price,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? goldColor : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.originalPrice,
              style: const TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? goldColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                plan.description,
                style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
