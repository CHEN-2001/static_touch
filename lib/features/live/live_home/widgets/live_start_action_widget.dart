import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class LiveStartActionWidget extends StatefulWidget {
  const LiveStartActionWidget({super.key});

  @override
  State<LiveStartActionWidget> createState() => _LiveStartActionWidgetState();
}

class _LiveStartActionWidgetState extends State<LiveStartActionWidget> {
  bool _isChecking = false;

  void _handleStartLive(BuildContext context) async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    try {
      final repo = locator<LiveRepository>();
      final currentUserId = context.read<UserStateProvider>().user.id.toString();

      final result = await repo.fetchTodayLiveList();
      String? scheduledId;

      if (result.status && result.data != null) {
        final List list = result.data as List;
        for (var item in list) {
          if (item['statusCode'] == 0 && item['anchorId']?.toString() == currentUserId) {
            scheduledId = item['id']?.toString();
            break;
          }
        }
      }
      setState(() => _isChecking = false);

      if (!context.mounted) return;

      if (scheduledId != null) {
        final bool? useSchedule = await context.showAppDialog(
          title: '检测到预告',
          content: '您有一个待开播的预发布房间，是否直接使用该预告开播？\n\n(选择重新创建将废除旧预告创建新房间)',
          confirmText: '使用预告',
          cancelText: '重新创建',
        );

        if (useSchedule == true) {
          context.push(AppRoutes.livePrepare, extra: {'scheduledLiveId': scheduledId});
        } else if (useSchedule == false) {
          context.push(AppRoutes.livePrepare);
        }
      } else {
        context.push(AppRoutes.livePrepare);
      }
    } catch (e) {
      setState(() => _isChecking = false);
      context.showAppToast(message: '状态核验异常，请稍后再试', type: AppToastType.error);
    }
  }

  /// 显示发布预直播弹窗
  void _showCreateScheduleDialog(BuildContext context) {
    final titleController = TextEditingController();
    final introController = TextEditingController();
    DateTime? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('发布预直播', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // 使用 SingleChildScrollView 防止键盘弹出时界面溢出报错
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 直播标题输入框
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: '直播标题',
                      hintText: '请输入直播标题',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. 直播简介输入框
                  TextField(
                    controller: introController,
                    decoration: InputDecoration(
                      labelText: '直播简介',
                      hintText: '简单介绍一下本次直播的内容...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3, // 多行输入
                  ),
                  const SizedBox(height: 16),

                  // 3. 开播时间选择器
                  const Text('开播时间', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      // 步骤A：选择日期
                      final date = await showDatePicker(
                        context: dialogContext,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(), // 限制只能选今天及以后的日期
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );

                      if (date != null) {
                        // 步骤B：选择时间
                        final time = await showTimePicker(context: dialogContext, initialTime: TimeOfDay.now());

                        if (time != null) {
                          // 步骤C：合并日期和时间并更新UI
                          setState(() {
                            selectedTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedTime == null
                            ? '请点击选择开播时间'
                            : '${selectedTime!.year}-${selectedTime!.month.toString().padLeft(2, '0')}-${selectedTime!.day.toString().padLeft(2, '0')} ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedTime == null ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('取消', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final intro = introController.text.trim();

                  // --- 替换为使用您项目的 showAppToast 校验 ---
                  if (title.isEmpty) {
                    dialogContext.showAppToast(message: '请填写直播标题', type: AppToastType.warning);
                    return;
                  }
                  if (intro.isEmpty) {
                    dialogContext.showAppToast(message: '请填写直播简介', type: AppToastType.warning);
                    return;
                  }
                  if (selectedTime == null) {
                    dialogContext.showAppToast(message: '请选择开播时间', type: AppToastType.warning);
                    return;
                  }
                  if (selectedTime!.isBefore(DateTime.now())) {
                    dialogContext.showAppToast(message: '开播时间不能早于当前时间', type: AppToastType.warning);
                    return;
                  }

                  // --- 校验通过，执行发布逻辑 ---
                  debugPrint('准备发布: 标题=$title, 简介=$intro, 时间=$selectedTime');

                  // 操作成功后关闭弹窗
                  Navigator.pop(ctx);
                },
                child: const Text(
                  '发布',
                  style: TextStyle(color: Color(0xFF8B2323), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF8B2323),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
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
                    '开启直播',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 24, color: Colors.white30),
          PopupMenuButton<String>(
            icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 22),
            offset: const Offset(0, -60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (value) {
              if (value == 'schedule') _showCreateScheduleDialog(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'schedule',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Color(0xFF8B2323), size: 18),
                    SizedBox(width: 8),
                    Text('发布预直播'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
