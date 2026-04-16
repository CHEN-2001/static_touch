import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/providers/user_state_provider.dart';

class MineHeader extends StatelessWidget {
  const MineHeader({super.key});

  static const _goldColor = Color(0xFFD4AF37);
  static const _textColor = Color(0xFF3D2B1F);

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserStateProvider provider) => provider.user);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(),
        const SizedBox(height: 16),
        Text(
          user.nickName.isEmpty ? '' : user.nickName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textColor),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: _goldColor,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      // child: user.avatarUrl.isNotEmpty ? ClipOval(child: Image.network(user.avatarUrl)) : null,
    );
  }
}
