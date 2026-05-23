import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/skeleton_block.dart';

class DurationCard extends StatelessWidget {
  const DurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFF5E6CA);
    const primaryColor = Color(0xFF4A2B11);
    const iconColor = Color(0xFFD4AF37);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.stats),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('累计静心时长', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 10),

                  // 接入数据与骨架屏
                  Consumer<UserStateProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const SkeletonBlock(width: 100, height: 28);
                      }
                      return Text(
                        '${provider.totalDuration} 分钟',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                      );
                    },
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}
