import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// token管理
class TokenManager {
  static const String _tokenKey = 'static_touch_token';
  static const _storage = FlutterSecureStorage();

  // 存
  static Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 取
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 删
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // 验证是否已登录
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
