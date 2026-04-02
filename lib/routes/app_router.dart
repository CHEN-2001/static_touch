import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 导入页面和 Provider
import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/main/main_page.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'package:static_touch/pages/mine/mine_provider.dart';
import 'package:static_touch/pages/settings/settings_provider.dart';
import 'package:static_touch/pages/notice/notice_page.dart';
import 'package:static_touch/pages/notice/notice_provider.dart';
import 'package:static_touch/pages/notice/notice_detail_page.dart';
import 'package:static_touch/pages/nfc/nfc_page.dart';
import 'package:static_touch/pages/nfc/nfc_provider.dart';
import 'package:static_touch/pages/live/live_prepare_page.dart';
import 'package:static_touch/pages/live/live_detail_page.dart';

class AppRouter {
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
      // 登录页：局部注入，登录完销毁，不占内存
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
              ChangeNotifierProvider(create: (_) => MineProvider()),
              ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ],
            child: const MainPage(),
          ),
        ),
      ),

      // 通知/公告 (局部注入)
      GoRoute(
        path: '/notice',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NoticeProvider(), child: const NoticePage()),
        ),
      ),

      // 通知详细页路由定义
      GoRoute(
        path: '/noticeDetail',
        pageBuilder: (context, state) {
          // 解析参数
          final data = state.extra as Map<String, dynamic>? ?? {};
          return fadePage(
            key: state.pageKey,
            child: NoticeDetailPage(
              title: data['title'] ?? '系统公告',
              // 如果需要，也可以把消息列表传过去
              initialMessages: data['messages']?.cast<String>() ?? ['暂无详情内容'],
            ),
          );
        },
      ),

      // NFC (局部注入)
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
