import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class AuthRepository {
  final HttpClient _client;
  AuthRepository(this._client);

  // 账号密码登录
  Future<ResultEntity> loginWithPassword(String email, String password) async {
    final result = await _client.post(ApiEndpoints.login, data: {'email': email, 'password': password});
    if (result.status && result.data != null) {
      final accessToken = result.data['accessToken']?.toString();
      final refreshToken = result.data['refreshToken']?.toString();
      if (accessToken != null && refreshToken != null) {
        await TokenManager.setAllToken(accessToken, refreshToken);
      }
    }
    return result;
  }

  // 发送邮箱验证码
  Future<ResultEntity> sendCaptcha(String email) async {
    return await _client.post(ApiEndpoints.sendCaptcha, queryParameters: {'email': email});
  }

  // 用户注册
  Future<ResultEntity> register({required String email, required String password, required String captcha}) async {
    return await _client.post(ApiEndpoints.register, data: {'email': email, 'password': password, 'captcha': captcha});
  }

  // 找回/重置密码
  Future<ResultEntity> resetPassword({
    required String email,
    required String newPassword,
    required String captcha,
  }) async {
    return await _client.post(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'password': newPassword, 'captcha': captcha},
    );
  }

  // NFC 登录
  Future<ResultEntity> loginByNfc(String nfcId) async {
    final result = await _client.post(ApiEndpoints.nfcLogin, data: {'nfcId': nfcId});

    if (result.status && result.data != null) {
      final accessToken = result.data['accessToken']?.toString();
      final refreshToken = result.data['refreshToken']?.toString();
      if (accessToken != null && refreshToken != null) {
        await TokenManager.setAllToken(accessToken, refreshToken);
      }
    }
    return result;
  }
}
