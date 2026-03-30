import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';

class DurationCard extends StatelessWidget {
  const DurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5E6CA)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('累计静心时长', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 10),
              Selector<HomeProvider, int>(
                selector: (_, p) => p.totalDuration,
                builder: (_, duration, __) =>
                    Text('$duration 分钟', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD4AF37)),
        ],
      ),
    );
  }
}
