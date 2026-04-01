import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 1. 导入页面
import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/main/main_page.dart';
import 'package:static_touch/pages/notice/notice_page.dart';
import 'package:static_touch/pages/notice/notice_detail_page.dart';
import 'package:static_touch/pages/nfc/nfc_page.dart';
import 'package:static_touch/pages/live/live_prepare_page.dart';
import 'package:static_touch/pages/live/live_detail_page.dart';

// 2. 导入 Provider
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'package:static_touch/pages/live/live_provider.dart';
import 'package:static_touch/pages/mine/mine_provider.dart';
import 'package:static_touch/pages/settings/settings_provider.dart';
import 'package:static_touch/pages/notice/notice_provider.dart';
import 'package:static_touch/pages/nfc/nfc_provider.dart';

class AppRouter {
  // 通用淡入淡出跳转效果：400ms 的平滑过渡
  static CustomTransitionPage<T> fadePage<T>({required LocalKey key, required Widget child}) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
        ),
      ),
      // 首页基座
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
      // 通知/公告
      GoRoute(
        path: '/notice',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NoticeProvider(), child: const NoticePage()),
        ),
      ),

      // 通知/公告详细
      GoRoute(
        path: '/noticeDetail',
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const NoticeDetailPage()),
      ),

      // NFC
      GoRoute(
        path: '/nfc',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NfcProvider(), child: const NfcPage()),
        ),
      ),

      // 准备直播
      GoRoute(
        path: '/livePrepare',
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const LivePreparePage()),
      ),

      // 直播详细
      GoRoute(
        path: '/liveDetailPage',
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const LiveDetailPage()),
      ),
    ],
  );
}
