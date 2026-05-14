import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_detail_provider.dart';

class LiveActions extends StatelessWidget {
  const LiveActions({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDetailProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // 保持你原本的高级黑设定
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. 关闭视频
          _buildBtn(
            icon: p.isAudioOnly ? Icons.videocam_off : Icons.videocam,
            label: p.isAudioOnly ? '已關視頻' : '關閉視頻',
            isActive: p.isAudioOnly,
            onTap: () => p.toggleAudioOnly(context),
          ),
          // 2. 白噪音
          _buildBtn(
            icon: Icons.waves,
            label: p.currentWhiteNoise ?? '白噪音',
            isActive: p.currentWhiteNoise != null,
            onTap: () => _showWhiteNoisePanel(context, p),
          ),
          // 3. 静心打卡
          _buildBtn(
            icon: p.hasCheckedIn ? Icons.how_to_reg : Icons.fingerprint,
            label: p.hasCheckedIn ? '已打卡' : '靜心打卡',
            isActive: p.hasCheckedIn,
            onTap: () => p.doCheckIn(context),
          ),
          // 4. 收藏
          _buildBtn(
            icon: p.isFavorited ? Icons.favorite : Icons.favorite_border,
            label: p.isFavorited ? '已收藏' : '收藏',
            isActive: p.isFavorited,
            onTap: () => p.toggleFavorite(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? const Color(0xFFD4AF37) : const Color(0xFFEFEBE4);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  // 严格落实 PRD: 白噪音面板与混音控制
  void _showWhiteNoisePanel(BuildContext context, LiveDetailProvider p) {
    final noises = ['細雨', '海浪', '篝火', '夏夜蟲鳴', '微風', '溪流'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return ChangeNotifierProvider.value(
          value: p,
          child: Consumer<LiveDetailProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "環境白噪音 (與直播混音)",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: noises.map((noise) {
                        final isSelected = provider.currentWhiteNoise == noise;
                        return GestureDetector(
                          onTap: () => provider.toggleWhiteNoise(noise),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD4AF37) : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              noise,
                              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    if (provider.currentWhiteNoise != null) ...[
                      const Text("音量調節", style: TextStyle(color: Colors.white54, fontSize: 12)),
                      Slider(
                        value: provider.whiteNoiseVolume,
                        activeColor: const Color(0xFFD4AF37),
                        inactiveColor: Colors.white12,
                        onChanged: (val) => provider.setWhiteNoiseVolume(val),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
