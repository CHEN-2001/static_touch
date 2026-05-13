import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_tab_provider.dart'; // 🚀 引入大管家
import 'widgets/main_app_bar.dart';
import 'widgets/main_tab_item.dart';

// 导入业务子页面
import 'package:static_touch/features/home/home_page.dart';
import 'package:static_touch/features/live/live_home/live_page.dart';
import 'package:static_touch/features/mine/mine_page.dart';
import 'package:static_touch/features/settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _pageController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 从管家那里拿初始索引
    final initialIndex = context.read<MainTabProvider>().currentIndex;
    _pageController = PageController(initialPage: initialIndex);

    // 固定的四个页面（未来如果要后端动态下发 Tab，这里的逻辑也能无缝对接）
    _pages = const [
      HomePage(key: ValueKey('home')),
      LivePage(key: ValueKey('live')),
      MinePage(key: ValueKey('mine')),
      SettingsPage(key: ValueKey('settings')),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      // 1. 顶部栏（内部已自闭环监听）
      appBar: const MainAppBar(),
      // 2. 中间内容区
      body: PageView(controller: _pageController, physics: const NeverScrollableScrollPhysics(), children: _pages),
      // 3. 底部栏
      bottomNavigationBar: _MainBottomBar(pageController: _pageController),
    );
  }
}

// 🚀 性能优化：将底部栏抽离，只在内部监听 Provider 刷新，不影响主体内容
class _MainBottomBar extends StatelessWidget {
  final PageController pageController;
  const _MainBottomBar({required this.pageController});

  @override
  Widget build(BuildContext context) {
    final double safeBottom = MediaQuery.paddingOf(context).bottom;

    // 🚀 监听管家的变化
    final provider = context.watch<MainTabProvider>();

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
            // 🚀 核心：通过管家的配置数组，动态生成底栏！不再写死！
            children: List.generate(provider.tabTitles.length, (index) {
              return Expanded(
                child: MainTabItem(
                  index: index,
                  currentIndex: provider.currentIndex,
                  icon: provider.tabIcons[index],
                  label: provider.tabTitles[index],
                  onTap: (i) => provider.switchTab(i, pageController),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
