import 'package:get_it/get_it.dart';
import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/shared/repositories/system_repository.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';
import 'package:static_touch/shared/repositories/live_repository.dart';
import 'package:static_touch/shared/repositories/collection_repository.dart';
import 'package:static_touch/features/auth/auth_repository.dart';
import 'package:static_touch/shared/repositories/nfc_repository.dart';
import 'package:static_touch/shared/repositories/vip_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 注册核心网络
  locator.registerLazySingleton<HttpClient>(() => HttpClient());
  // 注册系统仓库
  locator.registerCachedFactory<SystemRepository>(() => SystemRepository(locator()));
  // 注册用户仓库
  locator.registerLazySingleton<UserRepository>(() => UserRepository(locator()));
  locator.registerLazySingleton<LiveRepository>(() => LiveRepository(locator()));
  // 注册auth仓库
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator()));
  //注册收藏仓库
  locator.registerLazySingleton<CollectionRepository>(() => CollectionRepository(locator()));
  // 注册NFC仓库
  locator.registerLazySingleton<NfcRepository>(() => NfcRepository(locator()));
  // 注册VIP仓库
  locator.registerLazySingleton<VipRepository>(() => VipRepository(locator()));
}
