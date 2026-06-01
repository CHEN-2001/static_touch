import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/models/nfc/nfc_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import '../nfc_provider.dart';

// ================= 顶部 NFC 状态卡片 =================
class NfcHeaderCard extends StatelessWidget {
  final NfcDeviceModel device;
  const NfcHeaderCard({super.key, required this.device});

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: device.isBound
                ? const Color(0xFFEFEBE4)
                : Colors.grey.shade200,
            child: Icon(
              Icons.nfc,
              color: device.isBound ? const Color(0xFFD4AF37) : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            device.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: device.isBound
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              device.isBound ? '已绑定' : '未绑定',
              style: TextStyle(
                color: device.isBound ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            device.isBound ? 'NFC ID: ${device.id}' : '请先绑定您的专属音饰',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ================= 操作列表 =================
class NfcActionList extends StatelessWidget {
  final bool isBound;
  const NfcActionList({super.key, required this.isBound});

  @override
  Widget build(BuildContext context) {
    final p = context.read<NfcProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildActionRow(
            '重新绑定',
            trail: const Text(
              '去感应 >',
              style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14),
            ),
            onTap: () => p.simulateRebind(context), // 🚀 绑定新交互
          ),
          _buildActionRow(
            '音饰保养说明',
            trail: const Text(
              '了解详情 >',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            onTap: () => context.showAppToast(
              message: "保养说明页面开发中",
              type: AppToastType.warning,
            ),
          ),
          if (isBound) // 只有绑定状态才显示解除绑定
            _buildActionRow(
              '解除设备绑定',
              trail: const Icon(
                Icons.link_off,
                size: 16,
                color: Color(0xFFA63232),
              ),
              isLast: true,
              onTap: () => p.unbindDevice(context), // 🚀 绑定新交互
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    String title, {
    required Widget trail,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(isLast ? 12 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: title == '解除设备绑定'
                    ? const Color(0xFFA63232)
                    : const Color(0xFF333333),
              ),
            ),
            trail,
          ],
        ),
      ),
    );
  }
}
