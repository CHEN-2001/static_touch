import 'dart:async';
import 'package:static_touch/models/live_item_model.dart';
import 'package:static_touch/enum/live_status_enum.dart';

class LiveService {
  Future<List<LiveItemModel>> fetchLiveListFromApi() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      LiveItemModel(id: '1', title: '直播 A', startTime: DateTime.now(), status: LiveStatusEnum.finished),
      LiveItemModel(id: '2', title: '直播 B', startTime: DateTime.now(), status: LiveStatusEnum.ongoing),
      LiveItemModel(id: '3', title: '直播 C', startTime: DateTime.now(), status: LiveStatusEnum.upcoming),
    ];
  }

  // 模拟推流
  Stream<LiveItemModel> listenLiveUpdates() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));

      yield LiveItemModel(
        id: '2',
        title: '直播 B',
        startTime: DateTime.now(),
        status: LiveStatusEnum.finished, // 状态变了
      );
    }
  }
}
