import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 导入所有页面和 Provider
import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/main/main_page.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'package:static_touch/pages/live/live_provider.dart';
import 'package:static_touch/pages/mine/mine_provider.dart';
import 'package:static_touch/pages/settings/settings_page.dart';
import 'package:static_touch/pages/settings/settings_provider.dart';
import 'package:static_touch/pages/notice/notice_page.dart';
import 'package:static_touch/pages/notice/notice_provider.dart';
import 'package:static_touch/pages/notice/notice_detail_page.dart';
import 'package:static_touch/pages/nfc/nfc_page.dart';
import 'package:static_touch/pages/nfc/nfc_provider.dart';
import 'package:static_touch/pages/live/live_prepare_page.dart';

class AppRouter {
  // 封装通用的淡入淡出跳转效果
  static CustomTransitionPage<T> fadePage<T>({required LocalKey key, required Widget child}) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300), // 300ms 淡入淡出
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // 使用 FadeTransition 包装
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // 登录页
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
        ),
      ),

      // 主容器页 (包含 Home, Live, Mine 等切换)
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomeProvider()),
              ChangeNotifierProvider(create: (_) => LiveProvider()),
              ChangeNotifierProvider(create: (_) => MineProvider()),
              ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ],
            child: const MainPage(),
          ),
        ),
      ),

      // 设置页
      GoRoute(
        path: '/setting',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => SettingsProvider(), child: const SettingsPage()),
        ),
      ),

      // 消息通知页
      GoRoute(
        path: '/notice',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NoticeProvider(), child: const NoticePage()),
        ),
      ),

      // 系统公告详情页
      GoRoute(
        path: '/noticeDetail',
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const NoticeDetailPage()),
      ),

      // 我的 NFC 页
      GoRoute(
        path: '/nfc',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NfcProvider(), child: const NfcPage()),
        ),
      ),

      // 开启直播准备页
      GoRoute(
        path: '/livePrepare',
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const LivePreparePage()),
      ),
    ],
  );
}
