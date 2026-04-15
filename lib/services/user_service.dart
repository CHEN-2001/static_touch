import 'dart:async';
import 'package:static_touch/models/user/user_model.dart';

class UserService {
  Future<UserModel> fetchUserInfo() async {
    return UserModel(
      id: 1,
      nickName: "不二法门",
      avatarUrl: "https://example.com/avatar.png",
      dailyQuote: "随缘而行，不离自性。",
      totalDuration: 0,
    );
  }
}
