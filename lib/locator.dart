import 'package:get_it/get_it.dart';
import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';

// 业务仓库
import 'package:static_touch/features/auth/auth_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 注册核心网络
  locator.registerLazySingleton<HttpClient>(() => HttpClient());
  // 注册公共用户仓库
  locator.registerLazySingleton<UserRepository>(() => UserRepository(locator()));
  locator.registerLazySingleton<LiveRepository>(() => LiveRepository(locator()));
  // 注册auto仓库
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator()));
}
