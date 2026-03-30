import 'package:flutter/material.dart';
import 'package:static_touch/pages/main/widgets/main_tab_item.dart';
// 引入页面内容
import 'package:static_touch/pages/home/home_page.dart';
import 'package:static_touch/pages/live/live_page.dart';
import 'package:static_touch/pages/mine/mine_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 页面配置
  final List<Widget> _pages = const [HomePage(), LivePage(), MinePage(), Center(child: Text('设置中心'))];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // 底部导航栏
  Widget _buildBottomBar() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
      ),
      child: Row(
        children: [
          _createTab(0, Icons.home, '首页'),
          _createTab(1, Icons.live_tv, '直播'),
          _createTab(2, Icons.person, '我的'),
          _createTab(3, Icons.settings, '设置'),
        ],
      ),
    );
  }

  // 封装导航栏单个容器
  Widget _createTab(int index, IconData icon, String label) {
    return MainTabItem(
      index: index,
      currentIndex: _currentIndex,
      icon: icon,
      label: label,
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
