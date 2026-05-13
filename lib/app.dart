import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserStateProvider()),
        ChangeNotifierProvider(create: (_) => LiveStateProvider()),
      ],
      child: MaterialApp.router(
        title: '静触',
        theme: ThemeData(
          primaryColor: const Color(0xFF9E2A2B),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF9E2A2B),
            selectionHandleColor: Color(0xFF9E2A2B),
            selectionColor: Color(0x339E2A2B),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9E2A2B)),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
