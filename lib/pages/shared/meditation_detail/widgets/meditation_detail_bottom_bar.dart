import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/pages/shared/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/enum/live_status_enum.dart';
import 'package:static_touch/widgets/app_dialogs.dart';

class MeditationDetailBottomBar extends StatelessWidget {
  const MeditationDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, bottomPadding + 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Consumer<MeditationDetailProvider>(
        builder: (context, provider, _) {
          final data = provider.detail;
          if (data == null) return const SizedBox.shrink();
          final bool isFinished = data.status == LiveStatusEnum.finished;
          return isFinished
              ? _PlaybackButton(onPressed: () => _handlePlayback(context))
              : _RemindButton(isReminded: provider.isReminded, onPressed: () => _handleRemind(context, provider));
        },
      ),
    );
  }

  // 业务逻辑抽离
  void _handlePlayback(BuildContext context) {
    context.showAppToast(message: "回放加载中...", type: AppToastType.success);
  }

  Future<void> _handleRemind(BuildContext context, MeditationDetailProvider provider) async {
    bool? confirm = await context.showAppDialog(title: "设置提醒", content: "课程开始前将提醒您。");
    if (confirm == true) {
      provider.toggleRemind(provider.detail!.id);
      if (context.mounted) {
        context.showAppToast(message: "设置成功", type: AppToastType.success);
      }
    }
  }
}

// 2. 将按钮稍微拆分，避免 build 方法过于臃肿
class _PlaybackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _PlaybackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B2323),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "查看回放",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RemindButton extends StatelessWidget {
  final bool isReminded;
  final VoidCallback onPressed;
  const _RemindButton({required this.isReminded, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeRed = const Color(0xFF8B2323);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isReminded ? Colors.grey.shade400 : themeRed, width: 1.5),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isReminded ? "已设置提醒" : "提醒我",
        style: TextStyle(color: isReminded ? Colors.grey.shade600 : themeRed, fontWeight: FontWeight.bold),
      ),
    );
  }
}
