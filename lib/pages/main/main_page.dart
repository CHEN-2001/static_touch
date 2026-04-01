import 'package:flutter/material.dart';
import 'package:static_touch/pages/main/widgets/main_tab_item.dart';

// 引入页面内容
import 'package:static_touch/pages/home/home_page.dart';
import 'package:static_touch/pages/live/live_page.dart';
import 'package:static_touch/pages/mine/mine_page.dart';
import 'package:static_touch/pages/settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(key: ValueKey(0)),
      const LivePage(key: ValueKey(1)),
      const MinePage(key: ValueKey(2)),
      const SettingsPage(key: ValueKey(3)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400), // 切换动画时长
        switchInCurve: Curves.easeInOut, // 进入时的曲线
        switchOutCurve: Curves.easeInOut, // 退出时的曲线
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // 底部导航栏逻辑
  Widget _buildBottomBar() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))],
      ),
      child: Row(
        children: [
          _createTab(0, Icons.home_rounded, '首页'),
          _createTab(1, Icons.live_tv_rounded, '直播'),
          _createTab(2, Icons.person_rounded, '我的'),
          _createTab(3, Icons.settings_rounded, '设置'),
        ],
      ),
    );
  }

  // 封装导航栏单个 Tab 项目
  Widget _createTab(int index, IconData icon, String label) {
    return MainTabItem(
      index: index,
      currentIndex: _currentIndex,
      icon: icon,
      label: label,
      onTap: (index) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    );
  }
}
