import 'package:static_touch/models/live_item.dart';
import 'package:static_touch/enum/live_static.dart';

class LiveService {
  // 模拟从后端获取 JSON 并解析
  Future<List<LiveItem>> fetchLiveListFromApi() async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟

    // 这里未来是 await dio.get(...)
    return [
      LiveItem(id: '1', title: '直播 A', startTime: DateTime.now(), status: LiveStatus.finished),
      LiveItem(id: '2', title: '直播 B', startTime: DateTime.now(), status: LiveStatus.ongoing),
    ];
  }
}
