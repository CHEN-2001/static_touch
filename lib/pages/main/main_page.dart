import 'package:flutter/material.dart';
// 导入组件
import 'package:static_touch/pages/main/widgets/mian_app_bar.dart';
import 'package:static_touch/pages/main/widgets/main_tab_item.dart';
// 导入页面
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

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: MainAppBar(currentIndex: _currentIndex),
      body: RepaintBoundary(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: _MainBottomBar(currentIndex: _currentIndex, onTap: _onTabTapped),
    );
  }
}

class _MainBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MainBottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double safeBottom = MediaQuery.paddingOf(context).bottom;

    return RepaintBoundary(
      child: Container(
        height: 60 + safeBottom,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: safeBottom),
          child: Row(
            children: [
              _buildTab(0, Icons.home_rounded, '首页'),
              _buildTab(1, Icons.live_tv_rounded, '直播'),
              _buildTab(2, Icons.person_rounded, '我的'),
              _buildTab(3, Icons.settings_rounded, '设置'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    return Expanded(
      child: MainTabItem(index: index, currentIndex: currentIndex, icon: icon, label: label, onTap: onTap),
    );
  }
}
