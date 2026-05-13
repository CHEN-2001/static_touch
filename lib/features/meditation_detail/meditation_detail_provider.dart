import 'package:flutter/material.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/models/live/live_detailed_model.dart';
import 'package:static_touch/features/meditation_detail/live_detailed_service.dart';

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
    _detail = await _service.fetchDetailFromApi(item);
    _isLoading = false;
    notifyListeners();
  }

  // 切换提醒
  Future<void> toggleRemind(int itemId) async {
    final newValue = !_isReminded;
    await _service.setReminder(itemId, newValue);
    _isReminded = newValue;
    notifyListeners();
  }
}
