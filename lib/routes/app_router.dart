import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// 载入
import 'package:static_touch/features/splash/splash_page.dart';
// 首页基座
import 'package:static_touch/features/main_tab/main_page.dart';

// 认证模块 (auth)
import 'package:static_touch/features/auth/login/login_page.dart';
import 'package:static_touch/features/auth/login/login_provider.dart';
import 'package:static_touch/features/auth/register/register_page.dart';
import 'package:static_touch/features/auth/register/register_provider.dart';
import 'package:static_touch/features/auth/reset_password/reset_password_page.dart';
import 'package:static_touch/features/auth/reset_password/reset_password_provider.dart';

import 'package:static_touch/features/settings/settings_provider.dart';
import 'package:static_touch/features/notice/notice_page.dart';
import 'package:static_touch/features/notice/notice_provider.dart';
import 'package:static_touch/features/notice/notice_detail_page.dart';
import 'package:static_touch/features/nfc/nfc_page.dart';
import 'package:static_touch/features/nfc/nfc_provider.dart';
import 'package:static_touch/features/live/live_anchor/live_prepare_page.dart';
import 'package:static_touch/features/live/live_room/live_detail_page.dart';
import 'package:static_touch/features/stats/stats_page.dart';
import 'package:static_touch/features/meditation_detail/meditation_detail_page.dart';
import 'package:static_touch/features/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/features/live_data/live_data_page.dart';
import 'package:static_touch/features/live_data/live_data_provider.dart';
import 'package:static_touch/features/collections/collections_page.dart';
import 'package:static_touch/features/collections/collections_provider.dart';
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'package:static_touch/features/live/live_home/live_provider.dart';
import 'package:static_touch/features/live/live_anchor/live_prepare_provider.dart';
import 'package:static_touch/features/main_tab/main_tab_provider.dart';
import 'package:static_touch/features/live/live_room/live_detail_provider.dart';
import 'package:static_touch/features/mine/mine_provider.dart';
import 'package:static_touch/features/mine/profile_edit/profile_edit_page.dart';
import 'package:static_touch/features/mine/profile_edit/profile_edit_provider.dart';
import 'package:static_touch/features/mine/vip/vip_page.dart';
import 'package:static_touch/features/mine/vip/vip_provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';

// 定义路由路径常量
class AppRoutes {
  static const splash = '/splash';
  // 认证相关(auth)
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/resetPassword';
  static const main = '/main';
  static const notice = '/notice';
  static const noticeDetail = '/noticeDetail';
  static const nfc = '/nfc';
  static const livePrepare = '/livePrepare';
  static const liveDetail = '/liveDetailPage';
  static const stats = '/stats';
  static const meditationDetail = '/meditationDetail';
  static const liveData = '/liveDataProvider';
  static const collections = '/collections';
  static const profileEdit = '/profileEdit';
  static const vip = '/vip';
}

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
    navigatorKey: NavService.rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash 路由
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const SplashPage()),
      ),
      // 首页基座
      GoRoute(
        path: AppRoutes.main,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => MainTabProvider()),
              ChangeNotifierProvider(create: (_) => SettingsProvider()),
              ChangeNotifierProvider(create: (_) => LiveProvider()),
              ChangeNotifierProvider(create: (_) => MineProvider()),
            ],
            child: const MainPage(),
          ),
        ),
      ),
      /*          认证模块(认证)           */
      // 登录
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
        ),
      ),
      // 注册
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => RegisterProvider(), child: const RegisterPage()),
        ),
      ),
      // 忘记密码
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => ResetPasswordProvider(), child: const ResetPasswordPage()),
        ),
      ),
      // 通知/公告 (局部注入)
      GoRoute(
        path: AppRoutes.notice,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NoticeProvider(), child: const NoticePage()),
        ),
      ),
      // 通知详细页
      GoRoute(
        path: AppRoutes.noticeDetail,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return fadePage(
            key: state.pageKey,
            child: NoticeDetailPage(
              title: data['title'] ?? '系统公告',
              initialMessages: data['messages']?.cast<String>() ?? ['暂无详情内容'],
            ),
          );
        },
      ),
      // NFC (局部注入)
      GoRoute(
        path: AppRoutes.nfc,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NfcProvider(), child: const NfcPage()),
        ),
      ),
      // 准备直播
      GoRoute(
        path: AppRoutes.livePrepare,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => LivePrepareProvider(), // 注入新管家
            child: const LivePreparePage(),
          ),
        ),
      ),
      // 直播详细
      GoRoute(
        path: AppRoutes.liveDetail,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => LiveDetailProvider(), child: const LiveDetailPage()),
        ),
      ),
      // 统计数据
      GoRoute(
        path: AppRoutes.stats,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => UserStateProvider(), child: const StatsPage()),
        ),
      ),
      // 课程详细
      GoRoute(
        path: AppRoutes.meditationDetail,
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
        path: AppRoutes.liveData,
        pageBuilder: (context, state) {
          return fadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(create: (_) => LiveDataProvider(), child: const LiveDataPage()),
          );
        },
      ),
      // 收藏
      GoRoute(
        path: AppRoutes.collections,
        builder: (context, state) =>
            ChangeNotifierProvider(create: (_) => CollectionsProvider(), child: const CollectionsPage()),
      ),
      // 个人信息设置
      GoRoute(
        path: AppRoutes.profileEdit,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => ProfileEditProvider(), child: const ProfileEditPage()),
        ),
      ),
      // vip
      GoRoute(
        path: AppRoutes.vip,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => VipProvider(), child: const VipPage()),
        ),
      ),
    ],
  );
}
