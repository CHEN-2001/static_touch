class UserModel {
  final int id;
  final String nickName;
  final String avatarUrl;
  final String dailyQuote;
  final int totalDuration;
  UserModel({this.id = 0, this.nickName = '', this.avatarUrl = '', this.dailyQuote = '', this.totalDuration = 0});

  factory UserModel.empty() => UserModel(id: -1, nickName: '加载中...', avatarUrl: '', totalDuration: 0);

  // 3. 从 JSON 解析时进行保底（全栈开发最关键的一步）
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nickName: json['nickName']?.toString() ?? 'user',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      dailyQuote: json['dailyQuote']?.toString() ?? '',
      // 强制转为 int，最稳妥的做法
      totalDuration: int.tryParse(json['totalDuration']?.toString() ?? '0') ?? 0,
    );
  }
}
