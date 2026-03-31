import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_provider.dart';

class LiveChatList extends StatelessWidget {
  const LiveChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final danmus = context.watch<LiveProvider>().danmuList;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: danmus.length,
      itemBuilder: (context, index) {
        final item = danmus[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${item['user']}: ',
                  style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: item['content']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
