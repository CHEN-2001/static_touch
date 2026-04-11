import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/pages/home/home_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<HomeProvider, String>(
          selector: (_, p) => p.userName,
          builder: (_, name, __) => Text(
            '早安，$name',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
          ),
        ),
        const SizedBox(height: 4),
        Selector<HomeProvider, String>(
          selector: (_, p) => p.dailyQuote,
          builder: (_, quote, __) => Text(quote, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ],
    );
  }
}
