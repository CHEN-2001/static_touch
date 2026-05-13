import 'package:flutter/material.dart';
import 'package:static_touch/features/collections/models/collection_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart'; // 导入枚举

class CollectionsProvider extends ChangeNotifier {
  List<CollectionItem> _items = [];
  List<CollectionItem> get items => _items;

  void fetchCollections() {
    _items = [
      CollectionItem(
        id: "c1",
        title: "深度冥想：能量流转",
        coverUrl: "https://example.com/1.jpg",
        duration: "45min",
        date: "2026-04-01",
        status: LiveStatus.ended, // 🚀 规范：已结束
      ),
      CollectionItem(
        id: "c2",
        title: "晚间助眠修行",
        coverUrl: "https://example.com/2.jpg",
        duration: "30min",
        date: "2026-04-05",
        status: LiveStatus.preparing, // 🚀 规范：准备中
      ),
    ];
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
