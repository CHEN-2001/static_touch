import 'package:flutter/material.dart';

// 🚀 直播数据模型
class LiveItem {
  final String title;
  final String status; // '直播中', '未开始', '已结束'
  final String coverUrl;

  LiveItem({required this.title, required this.status, required this.coverUrl});
}

class LiveProvider with ChangeNotifier {
  // 模拟状态
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  // 🚀 模拟数据源（大厂通常按 Tab 索引分批请求）
  final List<LiveItem> _allLives = [
    LiveItem(title: '直播标题占位符', status: '直播中', coverUrl: '...'),
    LiveItem(title: '直播标题占位符', status: '未开始', coverUrl: '...'),
    LiveItem(title: '直播标题占位符', status: '已结束', coverUrl: '...'),
    // 多加几个模拟数据
    LiveItem(title: '直播标题占位符2', status: '直播中', coverUrl: '...'),
    LiveItem(title: '直播标题占位符2', status: '已结束', coverUrl: '...'),
  ];

  // 💡 关键：根据当前 Tab 索引动态过滤列表
  List<LiveItem> get filteredLives {
    if (_currentTabIndex == 0) return _allLives; // '全部'

    // 映射 Tab 索引到状态字符串
    String targetStatus = '';
    switch (_currentTabIndex) {
      case 1:
        targetStatus = '直播中';
        break;
      case 2:
        targetStatus = '已结束';
        break;
      case 3:
        targetStatus = '即将开始';
        break; // 对应图片上的即将开始
    }
    return _allLives.where((item) => item.status == targetStatus).toList();
  }

  // 🚀 切换 Tab 方法
  void setTabIndex(int index) {
    _currentTabIndex = index;
    // 💡 这里可能会触发表格请求新状态的数据
    notifyListeners(); // 通知 UI 更新
  }

  // 🚀 模拟“开启直播”方法
  void startLive() {
    print('模拟跳转到开启直播页面');
    // 跳转逻辑或异步请求逻辑
  }
}
