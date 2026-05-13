import 'package:flutter/material.dart';
import 'dart:async';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';
import 'package:static_touch/locator.dart';

class LiveStateProvider with ChangeNotifier {
  final LiveRepository _liveRepo = locator<LiveRepository>();
  List<LiveItemModel> _items = [];
  StreamSubscription? _liveSubscription;

  List<LiveItemModel> get items => _items;

  Future<void> initAndRefresh() async {
    await refreshLiveList();
    startListeningUpdates();
  }

  Future<void> refreshLiveList() async {
    try {
      _items = await _liveRepo.fetchLiveListFromApi();
      notifyListeners();
    } catch (e) {}
  }

  void startListeningUpdates() {
    _liveSubscription?.cancel();
    _liveSubscription = _liveRepo.listenLiveUpdates().listen((updatedItem) {
      final newList = List<LiveItemModel>.from(_items);

      int index = newList.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        newList[index] = updatedItem;
        debugPrint("--- 监听到更新：直播 ${updatedItem.id} 状态变为 ${updatedItem.status.tag} ---");
      } else {
        newList.insert(0, updatedItem);
        debugPrint("--- 监听到新增：新直播 ${updatedItem.id} 已插入 ---");
      }

      _items = newList;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _liveSubscription?.cancel();
    super.dispose();
  }
}
