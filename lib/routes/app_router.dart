import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/main/main_page.dart';
import 'package:static_touch/pages/home/home_page.dart';
import 'package:static_touch/pages/home/home_provider.dart';
import 'package:static_touch/pages/live/live_page.dart';
import 'package:static_touch/pages/live/live_provider.dart';
import 'package:static_touch/pages/mine/mine_page.dart';
import 'package:static_touch/pages/mine/mine_provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
      ),

      GoRoute(
        path: '/main',
        builder: (context, state) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomeProvider()),
              ChangeNotifierProvider(create: (_) => LiveProvider()),
              ChangeNotifierProvider(create: (_) => MineProvider()),
            ],
            child: const MainPage(),
          );
        },
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => ChangeNotifierProvider(create: (_) => HomeProvider(), child: const HomePage()),
      ),
      GoRoute(
        path: '/live',
        builder: (context, state) => ChangeNotifierProvider(create: (_) => LiveProvider(), child: const LivePage()),
      ),
      GoRoute(
        path: '/live',
        builder: (context, state) => ChangeNotifierProvider(create: (_) => LiveProvider(), child: const LivePage()),
      ),
      GoRoute(
        path: '/mine',
        builder: (context, state) => ChangeNotifierProvider(create: (_) => MineProvider(), child: const MinePage()),
      ),
    ],
  );
}
