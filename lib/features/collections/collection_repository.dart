import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/collection/collection_model.dart';
import 'package:static_touch/shared/enum/live_status_enum.dart';

class CollectionRepository {
  final HttpClient _client;
  CollectionRepository(this._client);

  static const bool isMock = true;

  Future<ResultEntity<List<CollectionItem>>> fetchCollections() async {
    if (!isMock) {
      // 真实 API 请求预留
      // final res = await _client.get('/collections/list');
    }

    // --- 模拟数据 ---
    await Future.delayed(const Duration(milliseconds: 600));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: [
        CollectionItem(
          id: "c1",
          title: "深度冥想：能量流转",
          coverUrl: "https://example.com/1.jpg",
          duration: "45min",
          date: "2026-04-01",
          status: LiveStatus.ended,
        ),
        CollectionItem(
          id: "c2",
          title: "晚间助眠修行",
          coverUrl: "https://example.com/2.jpg",
          duration: "30min",
          date: "2026-04-05",
          status: LiveStatus.preparing,
        ),
      ],
    );
  }
}
