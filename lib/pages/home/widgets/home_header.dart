import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/providers/user_state_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF8B2323);
    const quoteColor = Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<UserStateProvider, String>(
          selector: (context, provider) => provider.user.nickName,
          builder: (context, name, child) {
            final displayName = name.isEmpty ? '用户' : name;
            return Text(
              '早安，$displayName',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: titleColor),
            );
          },
        ),
        const SizedBox(height: 4),
        Selector<UserStateProvider, String>(
          selector: (context, provider) => provider.dailyQuote,
          builder: (context, quote, child) {
            return Text(quote, style: const TextStyle(color: quoteColor, fontSize: 12));
          },
        ),
      ],
    );
  }
}
