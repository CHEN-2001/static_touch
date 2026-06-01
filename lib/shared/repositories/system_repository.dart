import 'package:static_touch/core/network/api_endpoints.dart';
import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';

class SystemRepository {
  final HttpClient _client;
  SystemRepository(this._client);

  //获取每日语句
  Future<ResultEntity<String>> fetchDailyQuote() async {
    final result = await _client.get(ApiEndpoints.dailyQuote);
    if (result.status && result.data != null) {
      return ResultEntity(status: true, message: '获取成功', data: result.data);
    }
    return ResultEntity.error(result.message);
  }
}
