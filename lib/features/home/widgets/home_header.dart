import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/system_state_provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/skeleton_block.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _titleStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF8B2323));
  static const _quoteStyle = TextStyle(color: Colors.grey, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserStateProvider, SystemStateProvider>(
      builder: (context, provider, systemProvider, child) {
        if (provider.isLoading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBlock(width: 220, height: 32),
              SizedBox(height: 8),
              SkeletonBlock(width: 180, height: 16),
            ],
          );
        }

        final displayName = provider.user.nickName.isEmpty ? '用户' : provider.user.nickName;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${provider.greeting}，$displayName', style: _titleStyle),
            const SizedBox(height: 4),
            if (systemProvider.dailyQuote.isNotEmpty) Text(systemProvider.dailyQuote, style: _quoteStyle),
          ],
        );
      },
    );
  }
}
