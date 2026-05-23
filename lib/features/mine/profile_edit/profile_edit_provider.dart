import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/user_repository.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:provider/provider.dart';

class ProfileEditProvider extends BaseProvider {
  final UserRepository _repo = locator<UserRepository>();

  String? _localAvatarPath;
  String? get localAvatarPath => _localAvatarPath;

  // 🚀 真实的图片选择逻辑
  Future<void> pickNewAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80, // 压缩图片质量，防止文件过大
        maxWidth: 800, // 限制最大宽度
      );

      if (image != null) {
        _localAvatarPath = image.path; // 获取真实的本地文件路径
        notifyListeners();
      }
    } catch (e) {
      setError("图片选择失败，请检查相机或相册权限");
    }
  }

  Future<bool> saveProfile(BuildContext context, {required String nickname, required String dailyQuote}) async {
    if (nickname.isEmpty) {
      setError("昵称不能为空");
      return false;
    }

    setLoading(true);
    final result = await _repo.updateUserInfo(
      nickname: nickname,
      dailyQuote: dailyQuote,
      avatarUrl: _localAvatarPath, // 提交本地真实路径给接口
    );
    setLoading(false);

    if (result.status) {
      if (context.mounted) {
        await context.read<UserStateProvider>().initData(isSilent: true);
      }
      return true;
    } else {
      setError(result.message);
      return false;
    }
  }
}
