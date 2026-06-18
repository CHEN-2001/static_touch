import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ================= 原有页面导入 =================
import 'package:static_touch/features/splash/splash_page.dart';
import 'package:static_touch/features/main_tab/main_page.dart';
import 'package:static_touch/features/auth/login/login_page.dart';
import 'package:static_touch/features/auth/login/login_provider.dart';
import 'package:static_touch/features/auth/register/register_page.dart';
import 'package:static_touch/features/auth/register/register_provider.dart';
import 'package:static_touch/features/auth/reset_password/reset_password_page.dart';
import 'package:static_touch/features/auth/reset_password/reset_password_provider.dart';
import 'package:static_touch/features/home/home_provider.dart';
import 'package:static_touch/features/settings/settings_provider.dart';
import 'package:static_touch/features/notice/notice_page.dart';
import 'package:static_touch/features/notice/notice_provider.dart';
import 'package:static_touch/features/notice/notice_detail_page.dart';
import 'package:static_touch/features/mine/nfc/nfc_page.dart';
import 'package:static_touch/features/mine/nfc/nfc_provider.dart';
import 'package:static_touch/features/live/live_anchor/live_prepare_page.dart';
import 'package:static_touch/features/live/live_room/live_detail_page.dart';
import 'package:static_touch/features/stats/stats_page.dart';
import 'package:static_touch/features/meditation_detail/meditation_detail_page.dart';
import 'package:static_touch/features/meditation_detail/meditation_detail_provider.dart';
import 'package:static_touch/features/mine/live_data/live_data_page.dart';
import 'package:static_touch/features/mine/live_data/live_data_provider.dart';
import 'package:static_touch/features/mine/collections/collections_page.dart';
import 'package:static_touch/features/mine/collections/collections_provider.dart';
import 'package:static_touch/features/live/live_home/live_provider.dart';
import 'package:static_touch/features/live/live_anchor/live_prepare_provider.dart';
import 'package:static_touch/features/main_tab/main_tab_provider.dart';
import 'package:static_touch/features/live/live_room/live_detail_provider.dart';
import 'package:static_touch/features/mine/mine_provider.dart';
import 'package:static_touch/features/mine/profile_edit/profile_edit_page.dart';
import 'package:static_touch/features/mine/profile_edit/profile_edit_provider.dart';
import 'package:static_touch/features/mine/vip/vip_page.dart';
import 'package:static_touch/features/mine/vip/vip_provider.dart';

// 原有模型导入
import 'package:static_touch/shared/models/live/live_item_model.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/models/live/live_prepare_model.dart';

// ================= 商城模块新增导入 =================
import 'package:static_touch/features/shop/shop_page.dart';
import 'package:static_touch/features/shop/shop_provider.dart';
import 'package:static_touch/features/shop/product_detail_page.dart';
import 'package:static_touch/features/shop/cart_page.dart';
import 'package:static_touch/features/shop/order_list_page.dart';
import 'package:static_touch/features/shop/order_provider.dart';
import 'package:static_touch/features/shop/order_detail_page.dart';
import 'package:static_touch/features/shop/write_comment_page.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';

// 定义路由路径常量
class AppRoutes {
  static const splash = '/splash';
  // 认证相关
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

  // 商城与订单相关
  static const shop = '/shop';
  static const shopDetail = '/shopDetail';
  static const cart = '/cart';
  static const myOrders = '/myOrders';
  static const orderDetail = '/orderDetail';
  static const writeComment = '/writeComment';
}

class AppRouter {
  static CustomTransitionPage<T> fadePage<T>({required LocalKey key, required Widget child}) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
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
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const SplashPage()),
      ),
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
              ChangeNotifierProvider(create: (_) => HomeProvider()),
            ],
            child: const MainPage(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => RegisterProvider(), child: const RegisterPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => ResetPasswordProvider(), child: const ResetPasswordPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.notice,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NoticeProvider(), child: const NoticePage()),
        ),
      ),
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
      GoRoute(
        path: AppRoutes.nfc,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => NfcProvider(), child: const NfcPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.livePrepare,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) {
              final provider = LivePrepareProvider();
              final extra = state.extra as Map<String, dynamic>?;
              final model = extra?['liveModel'] as LivePrepareModel?;
              provider.init(model);
              return provider;
            },
            child: const LivePreparePage(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.liveDetail,
        pageBuilder: (context, state) {
          final liveId = state.extra as String? ?? '';
          return fadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(
              create: (_) => LiveDetailProvider(),
              child: LiveDetailPage(liveId: liveId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.stats,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => UserStateProvider(), child: const StatsPage()),
        ),
      ),
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
      GoRoute(
        path: AppRoutes.liveData,
        pageBuilder: (context, state) {
          return fadePage(
            key: state.pageKey,
            child: ChangeNotifierProvider(create: (_) => LiveDataProvider(), child: const LiveDataPage()),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.collections,
        builder: (context, state) =>
            ChangeNotifierProvider(create: (_) => CollectionsProvider(), child: const CollectionsPage()),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => ProfileEditProvider(), child: const ProfileEditPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.vip,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => VipProvider(), child: const VipPage()),
        ),
      ),

      // ================= 这里是新增的商城与订单相关路由 =================
      GoRoute(
        path: AppRoutes.shop,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          child: ChangeNotifierProvider(create: (_) => ShopProvider(), child: const ShopPage()),
        ),
      ),
      GoRoute(
        path: AppRoutes.shopDetail,
        pageBuilder: (context, state) {
          final product = state.extra as ProductModel;
          return fadePage(
            key: state.pageKey,
            // 正常传递，不加 const
            child: ProductDetailPage(product: product),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (context, state) => fadePage(
          key: state.pageKey,
          // CartProvider 是在 app.dart 全局注入的，这里直接给页面即可
          child: const CartPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.myOrders,
        pageBuilder: (context, state) => fadePage(key: state.pageKey, child: const OrderListPage()),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        pageBuilder: (context, state) {
          final order = state.extra as OrderModel;
          return fadePage(
            key: state.pageKey,
            // 修复点：去掉 const，因为 order 是运行时获取的动态变量
            child: OrderDetailPage(order: order),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.writeComment,
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return fadePage(
            key: state.pageKey,
            // 修复点：去掉 const，原因同上
            child: WriteCommentPage(orderId: params['orderId'] as String, item: params['item'] as CartItemModel),
          );
        },
      ),
    ],
  );
}
