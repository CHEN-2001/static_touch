import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';
import 'package:static_touch/pages/home/home_page.dart';

class AppRouter {
  // 单例模式或全局静态变量
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // 明确的初始入口
    // 全局路由表
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          // 在这里按需注入 Provider，极其干净，不会污染全局 Context
          return ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage());
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
