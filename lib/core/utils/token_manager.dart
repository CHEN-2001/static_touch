import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Token管理
class TokenManager {
  static const String _accessTokenKey = 'static_touch_accessToken';
  static const String _refreshTokenKey = 'static_touch_refreshToken';

  static const _storage = FlutterSecureStorage();

  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  // 存双Token
  static Future<void> setAllToken(String accessToken, String refreshToken) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  // 取AccessToken
  static Future<String?> getAccessToken() async {
    _cachedAccessToken ??= await _storage.read(key: _accessTokenKey);
    return _cachedAccessToken;
  }

  // 取RefreshToken
  static Future<String?> getRefreshToken() async {
    _cachedRefreshToken ??= await _storage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  // 删双token
  static Future<void> clearToken() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await Future.wait([_storage.delete(key: _accessTokenKey), _storage.delete(key: _refreshTokenKey)]);
  }

  // 验证是否已登录
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
