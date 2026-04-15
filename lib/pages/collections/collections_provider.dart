import 'package:flutter/material.dart';
import 'package:static_touch/pages/collections/models/collection_model.dart';
import 'package:static_touch/enum/live_status_enum.dart';

class CollectionsProvider extends ChangeNotifier {
  List<CollectionItem> _items = [];
  List<CollectionItem> get items => _items;

  void fetchCollections() {
    // 模拟数据
    _items = [
      CollectionItem(
        id: "c1",
        title: "深度冥想：能量流转",
        coverUrl: "https://example.com/1.jpg",
        duration: "45min",
        date: "2026-04-01",
        status: LiveStatusEnum.finished,
      ),
      CollectionItem(
        id: "c2",
        title: "晚间助眠修行",
        coverUrl: "https://example.com/2.jpg",
        duration: "30min",
        date: "2026-04-05",
        status: LiveStatusEnum.upcoming,
      ),
    ];
    notifyListeners();
  }

  // 移除收藏逻辑
  void removeItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
