import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 导入页面和 Provider
import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/main/main_page.dart';
import 'package:static_touch/pages/settings/settings_provider.dart';
import 'package:static_touch/pages/shared/notice/notice_page.dart';
import 'package:static_touch/pages/shared/notice/notice_provider.dart';
import 'package:static_touch/pages/shared/stats/stats_provider.dart';
import 'package:static_touch/pages/shared/notice/notice_detail_page.dart';
import 'package:static_touch/pages/shared/nfc/nfc_page.dart';
import 'package:static_touch/pages/shared/nfc/nfc_provider.dart';
import 'package:static_touch/pages/live/live_prepare_page.dart';
import 'package:static_touch/pages/live/live_detail_page.dart';
import 'package:static_touch/pages/shared/stats/stats_page.dart';
import 'package:static_touch/pages/shared/meditation_detail/meditation_detail_page.dart';
import 'package:static_touch/pages/shared/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/pages/shared/live_data/live_data_page.dart';
import 'package:static_touch/pages/shared/live_data/live_data_provider.dart';
import 'package:static_touch/pages/shared/collections/collections_page.dart';
import 'package:static_touch/pages/shared/collections/collections_provider.dart';
import 'package:static_touch/providers/live_state_provider.dart';
import 'package:static_touch/models/live/live_item_model.dart';
import 'package:static_touch/providers/user_state_provider.dart';

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
              ChangeNotifierProvider(create: (_) => UserStateProvider()),
              ChangeNotifierProvider(create: (_) => SettingsProvider()),
              ChangeNotifierProvider(create: (_) => LiveStateProvider()),
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
      GoRoute(
        path: '/stats',
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => StatsProvider(), child: const StatsPage()),
        ),
      ),
      // 路由定义
      GoRoute(
        path: '/meditationDetail',
        pageBuilder: (context, state) {
          final item = state.extra as LiveItemModel;
          return fadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => MeditationDetailProvider(),
              child: MeditationDetailPage(item: item),
            ),
          );
        },
      ),
      // 直播数据
      GoRoute(
        path: '/liveDataProvider',
        pageBuilder: (context, state) {
          return fadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(create: (_) => LiveDataProvider(), child: LiveDataPage()),
          );
        },
      ),
      // 收藏
      GoRoute(
        path: '/collections',
        builder: (context, state) =>
            ChangeNotifierProvider(create: (_) => CollectionsProvider(), child: const CollectionsPage()),
      ),
    ],
  );
}
