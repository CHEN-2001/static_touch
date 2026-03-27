import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:static_touch/pages/splash/splash_page.dart';
import 'package:static_touch/pages/home/home_page.dart';
import 'package:static_touch/pages/login/login_page.dart';
import 'package:static_touch/pages/login/login_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '静触',
      debugShowCheckedModeBanner: false, //去除左上角debug标志
      // 样式
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
      // 路由
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case '/login':
            return MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(create: (_) => LoginProvider(), child: const LoginPage()),
            );
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());
          default:
            return MaterialPageRoute(
              builder: (context) => const Scaffold(body: Center(child: Text('页面走丢了'))),
            );
        }
      },
    );
  }
}
