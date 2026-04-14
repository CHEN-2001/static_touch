import 'package:flutter/material.dart';
import 'package:static_touch/models/live_item_model.dart';
import 'package:static_touch/models/live_detailed_model.dart';
import 'package:static_touch/services/live_detailed_service.dart';

class MeditationDetailProvider extends ChangeNotifier {
  final MeditationService _service = MeditationService();

  MeditationScheduleModel? _detail;
  MeditationScheduleModel? get detail => _detail;

  bool _isReminded = false;
  bool get isReminded => _isReminded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 加载详情
  Future<void> loadDetail(LiveItemModel item) async {
    _isLoading = true;
    notifyListeners();

    try {
      _detail = await _service.fetchDetailFromApi(item);
    } catch (e) {
      // 处理错误
      print('加载失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 切换提醒
  Future<void> toggleRemind(String itemId) async {
    final newValue = !_isReminded;

    try {
      await _service.setReminder(itemId, newValue);
      _isReminded = newValue;
      notifyListeners();
    } catch (e) {
      print('设置提醒失败: $e');
    }
  }
}
