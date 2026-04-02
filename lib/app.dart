import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
// 导入 Provider
import 'package:static_touch/pages/live/live_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 这里的 MultiProvider 包裹了整个 MaterialApp
    // 意味着它的“电力”覆盖了 App 的每一个角落
    return MultiProvider(
      providers: [
        // 直播业务是核心，且涉及多个全屏路由跳转，必须全局
        ChangeNotifierProvider(create: (_) => LiveProvider()),
        // 以后像 UserProvider (登录状态) 也要放在这里
      ],
      child: MaterialApp.router(
        title: '静触',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF9E2A2B),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF9E2A2B),
            selectionHandleColor: Color(0xFF9E2A2B),
            selectionColor: Color(0x339E2A2B),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9E2A2B))),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
