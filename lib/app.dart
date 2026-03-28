import 'package:flutter/material.dart';
import 'package:static_touch/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 官方大厂写法：使用 .router 构造函数
    return MaterialApp.router(
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

      // 接入 go_router
      routerConfig: AppRouter.router,
    );
  }
}
