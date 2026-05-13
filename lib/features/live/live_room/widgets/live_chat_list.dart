import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_detail_provider.dart';

class LiveChatList extends StatelessWidget {
  const LiveChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final danmus = context.select((LiveDetailProvider p) => p.danmuList);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: danmus.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: '观众: ',
                  style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: danmus[index],
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
