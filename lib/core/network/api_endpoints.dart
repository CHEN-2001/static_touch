// api路径基础配置
class ApiEndpoints {
  // 基础域名
  static const String baseUrl = 'https://api.yourdomain.com/v1';

  // --- Auth 模块 ---
  static const String login = '/login';

  // --- Live 模块 ---
  static const String liveList = '/live/list';
  static const String liveDetail = '/live/detail';

  // --- 公共模块 ---
  static const String userInfo = '/user/info';
}
