import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';

class ProfileEditProvider extends BaseProvider {
  final UserRepository _repo = locator<UserRepository>();

  Future<bool> saveProfile({required String nickName, required String dailyQuote}) async {
    if (nickName.isEmpty) {
      setError("昵称不能为空");
      return false;
    }

    setLoading(true);
    final result = await _repo.updateUserInfo(nickName: nickName, dailyQuote: dailyQuote);
    setLoading(false);

    if (result.status) {
      // 🚀 核心：同步刷新全局状态
      await locator<UserStateProvider>().initData(isSilent: true);
      return true;
    } else {
      setError(result.message);
      return false;
    }
  }
}
