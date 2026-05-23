import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/stats/meditation_stats_model.dart';
import 'package:static_touch/shared/models/user/user_model.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class UserRepository {
  final HttpClient _client;
  UserRepository(this._client);

  // 获取用户信息
  Future<ResultEntity<UserModel>> fetchUserInfo() async {
    final result = await _client.get(ApiEndpoints.userInfo);
    if (result.status && result.data != null) {
      return ResultEntity(status: true, message: '获取成功', data: UserModel.fromJson(result.data));
    }
    return ResultEntity.error(result.message);
  }

  // 更新用户信息
  Future<ResultEntity<void>> updateUserInfo({
    required String nickname,
    required String dailyQuote,
    String? avatarUrl,
  }) async {
    return await _client.put(
      ApiEndpoints.userInfo,
      data: {'nickname': nickname, 'dailyQuote': dailyQuote, 'avatarUrl': ?avatarUrl},
    );
  }

  //获取用户观看数据
  Future<ResultEntity<MeditationStatsModel>> fetchUserStats() async {
    final result = await _client.get(ApiEndpoints.meditationStats);
    if (result.status && result.data != null) {
      return ResultEntity(status: true, message: '获取成功', data: MeditationStatsModel.fromJson(result.data));
    }
    return ResultEntity.error(result.message);
  }
}
