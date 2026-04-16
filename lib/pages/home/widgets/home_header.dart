import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/providers/user_state_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _titleStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF8B2323));

  static const _quoteStyle = TextStyle(color: Colors.grey, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<UserStateProvider, ({String greeting, String name})>(
          selector: (_, provider) => (greeting: provider.greeting, name: provider.user.nickName),
          builder: (context, data, _) {
            final displayName = data.name.isEmpty ? '用户' : data.name;
            return Text('${data.greeting}，$displayName', style: _titleStyle);
          },
        ),

        const SizedBox(height: 4),

        Selector<UserStateProvider, String>(
          selector: (_, provider) => provider.dailyQuote,
          builder: (context, quote, _) {
            if (quote.isEmpty) return const SizedBox.shrink();
            return Text(quote, style: _quoteStyle);
          },
        ),
      ],
    );
  }
}
