import 'package:flutter/material.dart';

class NfcHeaderCard extends StatelessWidget {
  const NfcHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFEFEBE4),
            child: Text('头像', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          const SizedBox(height: 12),
          const Text(
            'NFC 名称',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
            child: const Text('已绑定', style: TextStyle(color: Colors.green, fontSize: 12)),
          ),
          const SizedBox(height: 16),
          const Text('NFC ID: SN202303031234****', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
