import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class AuthRepository {
  final HttpClient _client;
  AuthRepository(this._client);

  // 🚀 核心架构设计：一键切换真实后台与本地模拟
  static const bool isMock = true;

  Future<ResultEntity> loginWithPassword(String account, String password) async {
    if (!isMock) {
      // 真实 API 请求
      final result = await _client.post(ApiEndpoints.login, data: {'username': account, 'password': password});
      if (result.status && result.data != null) {
        await TokenManager.setToken(result.data['token']);
      }
      return result;
    }

    // ================= 模拟数据区域 =================
    await Future.delayed(const Duration(seconds: 1));
    if (account == 'admin' && password == '123456') {
      await TokenManager.setToken('mock_fake_token_anchor');
      return ResultEntity(status: true, message: '登录成功', data: {'isAnchor': true});
    } else {
      return ResultEntity.error('账号或密码错误 (测试账号: admin / 123456)');
    }
  }

  Future<ResultEntity> loginByNfc(String nfcId) async {
    if (!isMock) {
      // return await _client.post('/login/nfc', data: {'nfcId': nfcId});
    }

    // ================= 模拟数据区域 =================
    await Future.delayed(const Duration(seconds: 1));
    await TokenManager.setToken('nfc_fake_token_$nfcId');
    return ResultEntity(status: true, message: 'NFC 登录成功');
  }
}
