class TimeService {
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return '早安';
    if (hour >= 11 && hour < 13) return '午安';
    if (hour >= 13 && hour < 18) return '下午好';
    if (hour >= 18 && hour < 24) return '晚上好';
    return '夜深了注意休息';
  }
}
