// api路径基础配置
class ApiEndpoints {
  // 基础域名
  static const String baseUrl = 'http://192.168.100.68:8080';

  // --- Auth 模块 ---
  static const String refreshToken = '/auth/refresh';
  static const String login = '/auth/login'; //登录
  static const String sendCaptcha = '/auth/captcha'; // 发送验证码
  static const String register = '/auth/register'; // 账户注册
  static const String resetPassword = '/auth/password/reset'; // 找回密码
  static const String nfcLogin = '/auth/nfc-login'; // NFC 登录路由
  // --- 用户信息模块 ---
  static const String meditationStats = '/meditation/stats'; //直播信息
  // --- Live 模块 ---
  static const String liveList = '/live/list';
  static const String liveDetail = '/live/detail';

  // --- 公共模块 ---
  static const String userInfo = '/user/profile';
}
