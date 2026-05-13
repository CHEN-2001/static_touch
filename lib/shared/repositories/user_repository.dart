import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/user/user_model.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class UserRepository {
  final HttpClient _client;
  UserRepository(this._client);

  static const bool isMock = true;

  Future<ResultEntity<UserModel>> fetchUserInfo() async {
    if (!isMock) {
      final result = await _client.get(ApiEndpoints.userInfo);
      if (result.status && result.data != null) {
        return ResultEntity(status: true, message: '获取成功', data: UserModel.fromJson(result.data));
      }
      return ResultEntity.error(result.message);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: UserModel(id: 1, nickName: "不二法门", totalDuration: 1220, dailyQuote: "随缘而行，不离自性。", isAnchor: true),
    );
  }

  // 🚀 新增：更新用户信息接口
  Future<ResultEntity> updateUserInfo({required String nickName, required String dailyQuote}) async {
    if (!isMock) {
      return await _client.post('/user/update', data: {'nickName': nickName, 'dailyQuote': dailyQuote});
    }

    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));
    return ResultEntity(status: true, message: '修改成功');
  }
}
