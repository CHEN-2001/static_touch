class UserModel {
  final int id;
  final String nickName;
  final String avatarUrl;
  final String dailyQuote;
  final int totalDuration;
  final bool isAnchor;
  UserModel({
    this.id = 0,
    this.nickName = '',
    this.avatarUrl = '',
    this.dailyQuote = '',
    this.totalDuration = 0,
    this.isAnchor = true,
  });

  factory UserModel.empty() => UserModel(id: -1, nickName: '加载中...', avatarUrl: '', totalDuration: 0);

  // 从 JSON 解析时进行保底
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nickName: json['nickName']?.toString() ?? 'user',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      dailyQuote: json['dailyQuote']?.toString() ?? '',
      // 强制转为 int，最稳妥的做法
      totalDuration: int.tryParse(json['totalDuration']?.toString() ?? '0') ?? 0,
      isAnchor: json['isAnchor'] ?? false,
    );
  }

  // ==========================================
  // 🚀 核心优化：重写相等运算符和哈希值
  // 作用：当后端返回同样的数据时，Provider 会认为状态未改变，从而阻止整个 UI 页面的无脑刷新！
  // ==========================================
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.nickName == nickName &&
        other.avatarUrl == avatarUrl &&
        other.dailyQuote == dailyQuote &&
        other.totalDuration == totalDuration;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nickName.hashCode ^ avatarUrl.hashCode ^ dailyQuote.hashCode ^ totalDuration.hashCode;
  }
}
