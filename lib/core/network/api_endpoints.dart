// api路径基础配置
class ApiEndpoints {
  // 基础域名
  static const String baseUrl = 'http://47.92.105.53:8081';
  // static const String baseUrl = 'http://192.168.100.68:8081';

  // --- 系统 模块 ---
  static const String dailyQuote = '/system//quote/random'; //每日语句
  // --- Auth 模块 ---
  static const String refreshToken = '/auth/refresh'; //令牌刷新
  static const String login = '/auth/login'; //登录
  static const String sendCaptcha = '/auth/captcha'; // 发送验证码
  static const String register = '/auth/register'; // 账户注册
  static const String resetPassword = '/auth/password/reset'; // 找回密码
  static const String nfcLogin = '/auth/nfc-login'; // NFC 登录路由
  // --- 用户信息模块 ---
  static const String userInfo = '/user/profile'; //用户信息
  static const String meditationStats = '/meditation/stats'; //观看直播数据

  // --- Live 模块 ---
  static const String liveSchedule = '/live/schedule'; //预发布直播
  static String liveCancel(String id) => '/live/$id/cancel'; //取消预发布
  static const String liveScheduleCheck = '/live/schedule/check'; // 检查是否已经预发布
  static const String liveDetail = '/live/detail'; // 直播间详情 (后接 /{id})
  static const String liveUpcoming = '/live/upcoming'; // 获取待开播列表
  static const String liveHistory = '/live/history'; // 获取历史记录分页
  static String liveEnterRoom(String liveId) => '/live/$liveId/enter';
  static const String reserveLive = '/live/reserve'; //直播预约相关
  static const String liveCreate = '/live/create'; //创建直播
  static const String liveEnd = '/live/end'; //结束直播
  static const String liveStart = '/live/start'; // 主播开播
  static const String liveBase = '/live';
  static const String liveToday = '/live/today'; //获取今日直播
  static const String livePage = '/live/page'; //获取分页直播

  static String get wsBaseUrl {
    if (baseUrl.startsWith('https')) {
      return baseUrl.replaceFirst('https', 'wss');
    } else if (baseUrl.startsWith('http')) {
      return baseUrl.replaceFirst('http', 'ws');
    }
    return 'ws://localhost:8080'; // 兜底默认值
  }
}
