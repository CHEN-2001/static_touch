import 'package:flutter/material.dart';
import 'package:static_touch/routes/app_router.dart';

class MineMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final bool anchorOnly;

  MineMenuItem({required this.title, required this.icon, required this.route, this.anchorOnly = false});
}

class MineProvider extends ChangeNotifier {
  final List<MineMenuItem> _allMenus = [
    MineMenuItem(title: '修行数据', icon: Icons.insert_chart_rounded, route: AppRoutes.stats),
    MineMenuItem(title: '我的收藏', icon: Icons.bookmark_rounded, route: AppRoutes.collections),
    MineMenuItem(title: '直播数据', icon: Icons.analytics_rounded, route: AppRoutes.liveData, anchorOnly: true),
    MineMenuItem(title: 'NFC 实体卡', icon: Icons.nfc_rounded, route: AppRoutes.nfc),
    MineMenuItem(title: '联系客服', icon: Icons.headset_mic_rounded, route: ''),
  ];

  List<MineMenuItem> getVisibleMenus(bool isAnchor) {
    return _allMenus.where((menu) => menu.anchorOnly ? isAnchor : true).toList();
  }
}
