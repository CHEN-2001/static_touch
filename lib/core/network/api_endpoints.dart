// api路径基础配置
class ApiEndpoints {
  // 基础域名
  static const String baseUrl = 'http://192.168.100.68:8080';

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
  static const String liveDetail = '/live/detail'; // 直播间详情 (后接 /{id})
  static const String liveCreate = '/live/create'; //创建直播
  static const String liveEnd = '/live/end'; //结束直播
  static const String liveStart = '/live/start'; // 主播开播
  static const String liveBase = '/live';
  static const String liveToday = '/live/today'; //获取今日直播
  static const String livePage = '/live/page'; //获取分页直播
  static const String liveSchedule = '/live/schedule';
}
