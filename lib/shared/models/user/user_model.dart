class UserModel {
  final int id;
  final String email;
  final String nickname;
  final String avatarUrl;
  final String dailyQuote;
  final bool isVip;
  final DateTime? vipExpireTime;
  final int role;

  UserModel({
    this.id = 0,
    this.email = '',
    this.nickname = '',
    this.avatarUrl = '',
    this.dailyQuote = '',
    this.isVip = false,
    this.vipExpireTime,
    this.role = 0,
  });

  factory UserModel.empty() =>
      UserModel(id: -1, email: '', nickname: '加载中...', avatarUrl: '', dailyQuote: '修行中...', isVip: false, role: 0);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    bool parseIsVip(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return false;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? 'user',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      dailyQuote: json['dailyQuote']?.toString() ?? '',
      isVip: parseIsVip(json['isVip']),
      vipExpireTime: parseDate(json['vipExpireTime']),
      role: int.tryParse(json['role']?.toString() ?? '0') ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.nickname == nickname &&
        other.avatarUrl == avatarUrl &&
        other.dailyQuote == dailyQuote &&
        other.isVip == isVip &&
        other.vipExpireTime == vipExpireTime &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        nickname.hashCode ^
        avatarUrl.hashCode ^
        dailyQuote.hashCode ^
        isVip.hashCode ^
        vipExpireTime.hashCode ^
        role.hashCode;
  }
}
