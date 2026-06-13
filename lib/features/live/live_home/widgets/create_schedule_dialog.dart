import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

const Color _kPrimaryRed = Color(0xFF8B2323);

class CreateScheduleDialog extends StatefulWidget {
  const CreateScheduleDialog({super.key});

  @override
  State<CreateScheduleDialog> createState() => _CreateScheduleDialogState();
}

class _CreateScheduleDialogState extends State<CreateScheduleDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _introCtrl;
  DateTime? _selectedTime;

  // 防止重复提交
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _introCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _introCtrl.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateTime() async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 30)),
      onConfirm: (date) {
        setState(() {
          _selectedTime = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.zh,
    );
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    final title = _titleCtrl.text.trim();
    final description = _introCtrl.text.trim();

    if (title.isEmpty) {
      context.showAppToast(message: '请填写直播标题', type: AppToastType.warning);
      return;
    }
    if (_selectedTime == null) {
      context.showAppToast(message: '请选择开播时间', type: AppToastType.warning);
      return;
    }
    if (_selectedTime!.isBefore(DateTime.now())) {
      context.showAppToast(message: '开播时间不能早于当前时间', type: AppToastType.warning);
      return;
    }

    // 通知ui刷新
    setState(() => _isSubmitting = true);

    try {
      final repo = locator<LiveRepository>();
      final result = await repo.scheduleLive(
        title: title,
        description: description,
        expectedStartTime: _selectedTime!.toIso8601String(),
      );

      if (!mounted) return;

      if (result.status) {
        context.showAppToast(message: '发布成功！', type: AppToastType.success);
        Navigator.pop(context);
      } else {
        context.showAppToast(message: result.message, type: AppToastType.error);
        if (result.code == 5005) {
          Navigator.pop(context);
          context.push(AppRoutes.liveData);
        }
      }
    } catch (e) {
      if (mounted) context.showAppToast(message: '发布失败，网络异常', type: AppToastType.error);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('发布预直播', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: '直播标题',
                hintText: '请输入直播标题',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _introCtrl,
              decoration: InputDecoration(
                labelText: '直播简介',
                hintText: '简单介绍一下本次直播的内容...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text('开播时间', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedTime == null ? '请点击选择开播时间' : _formatDateTime(_selectedTime!),
                  style: TextStyle(fontSize: 16, color: _selectedTime == null ? Colors.grey.shade600 : Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('取消', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: _kPrimaryRed),
                )
              : const Text(
                  '发布',
                  style: TextStyle(color: _kPrimaryRed, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
