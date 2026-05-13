import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
// 🚀 核心修正：引入 shared 下的正规模型
import 'package:static_touch/shared/models/notice/notice_model.dart';

class NoticeProvider extends BaseProvider {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  final List<String> tabs = ['全部', '公告', '提醒'];

  List<NoticeModel> _notices = [];

  List<NoticeModel> get displayNotices {
    if (_currentTabIndex == 0) return _notices;
    if (_currentTabIndex == 1)
      return _notices.where((e) => e.type == '系统').toList();
    return _notices.where((e) => e.type == '提醒').toList();
  }

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  Future<void> fetchNotices() async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));

    _notices = [
      NoticeModel(
        id: '1',
        type: '系统',
        title: '系统升级公告',
        content: '点击查看详细升级内容及补偿',
        time: '14:15',
        isRead: false,
        messages: ['感谢关注静触 App！', '今晚 24:00 将进行停机维护，预计 2 小时。'],
      ),
      NoticeModel(
        id: '2',
        type: '提醒',
        title: '预约开播提醒',
        content: '您预约的《晨间正念》即将开始',
        time: '09:00',
        isRead: false,
        messages: ['导师不二法门的《晨间正念》即将在 10 分钟后开播，请做好准备。'],
      ),
      NoticeModel(
        id: '3',
        type: '系统',
        title: '欢迎来到静触',
        content: '找回内心的平静',
        time: '昨天',
        isRead: true,
        messages: ['愿你在这里找到属于自己的一片净土。'],
      ),
    ];

    setLoading(false);
  }

  Future<void> markAllAsRead() async {
    final hasUnread = _notices.any((e) => !e.isRead);
    if (!hasUnread) {
      NavService.rootNavigatorKey.currentContext?.showAppToast(
        message: "暂无未读消息",
        type: AppToastType.warning,
      );
      return;
    }

    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 400));

    _notices = _notices
        .map(
          (e) => NoticeModel(
            id: e.id,
            type: e.type,
            title: e.title,
            content: e.content,
            time: e.time,
            isRead: true,
            messages: e.messages,
          ),
        )
        .toList();

    setLoading(false);
    NavService.rootNavigatorKey.currentContext?.showAppToast(
      message: "已全部标记为已读",
      type: AppToastType.success,
    );
  }
}
