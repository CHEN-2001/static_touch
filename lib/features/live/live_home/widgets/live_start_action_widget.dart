import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/live/live_home/live_provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'create_schedule_dialog.dart';

const Color _kPrimaryRed = Color(0xFF8B2323);

class LiveStartActionWidget extends StatefulWidget {
  const LiveStartActionWidget({super.key});

  @override
  State<LiveStartActionWidget> createState() => _LiveStartActionWidgetState();
}

class _LiveStartActionWidgetState extends State<LiveStartActionWidget> {
  bool _isChecking = false;

  Future<void> _handleStartLive(BuildContext context) async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    try {
      final liveModel = await context.read<LiveProvider>().checkScheduledLive();
      setState(() => _isChecking = false);
      if (!context.mounted) return;
      if (liveModel != null) {
        final bool? useSchedule = await context.showAppDialog(
          title: '检测到预告',
          content: '您有一个待开播的预发布房间，是否直接使用该预告开播？\n\n(选择重新创建将废除旧预告创建新房间)',
          confirmText: '使用预告',
          cancelText: '重新创建',
        );
        if (!context.mounted || useSchedule == null) return;
        context.push(AppRoutes.livePrepare, extra: useSchedule ? {'liveModel': liveModel} : null);
      } else {
        context.push(AppRoutes.livePrepare);
      }
    } catch (e) {
      setState(() => _isChecking = false);
      context.showAppToast(message: '状态核验异常，请稍后再试', type: AppToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _kPrimaryRed,
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      shadowColor: Colors.black45,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _handleStartLive(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    if (_isChecking)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    else
                      const Icon(Icons.videocam, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '去直播',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, height: 24, color: Colors.white30),
            Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.white10),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 22),
                offset: const Offset(0, -60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onSelected: (value) {
                  if (value == 'schedule') {
                    showDialog(context: context, builder: (_) => const CreateScheduleDialog());
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'schedule',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month, color: _kPrimaryRed, size: 18),
                        SizedBox(width: 8),
                        Text('发布预直播'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
