import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // 🚀 引入枚举
import 'profile_edit_provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _quoteCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserStateProvider>().user;
    _nameCtrl = TextEditingController(text: user.nickName);
    _quoteCtrl = TextEditingController(text: user.dailyQuote);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quoteCtrl.dispose();
    super.dispose();
  }

  // 🚀 呼出底部选择菜单
  void _showImageSourceActionSheet(
    BuildContext context,
    ProfileEditProvider p,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext safeContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF4A2B11)),
                title: const Text('拍照', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(safeContext);
                  p.pickNewAvatar(ImageSource.camera); // 调起相机
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF4A2B11),
                ),
                title: const Text('从相册选择', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(safeContext);
                  p.pickNewAvatar(ImageSource.gallery); // 调起相册
                },
              ),
              Container(height: 8, color: const Color(0xFFF5F5F5)),
              ListTile(
                title: const Center(
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                onTap: () => Navigator.pop(safeContext),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfileEditProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        title: const Text(
          "资料修改",
          style: TextStyle(
            color: Color(0xFF4A2B11),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          TextButton(
            onPressed: p.isLoading
                ? null
                : () async {
                    final success = await p.saveProfile(
                      context,
                      nickName: _nameCtrl.text,
                      dailyQuote: _quoteCtrl.text,
                    );
                    if (success && mounted) {
                      context.showAppToast(
                        message: "修改成功",
                        type: AppToastType.success,
                      );
                      Navigator.pop(context);
                    }
                  },
            child: Text(
              p.isLoading ? "提交中" : "保存",
              style: const TextStyle(
                color: Color(0xFF8B2323),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        children: [
          Center(child: _buildAvatarEditor(context, p)),
          const SizedBox(height: 40),
          _buildInputTile("昵称", _nameCtrl, "请输入您的昵称"),
          const SizedBox(height: 24),
          _buildInputTile("个人签名", _quoteCtrl, "写下此时此刻的心境...", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildAvatarEditor(BuildContext context, ProfileEditProvider p) {
    final hasNewAvatar = p.localAvatarPath != null;

    return GestureDetector(
      onTap: () => _showImageSourceActionSheet(context, p), // 点击触发弹窗
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5D5C5), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                // 🚀 核心逻辑：如果选中了新图片，使用 FileImage 读取真实文件；否则使用默认占位图
                image: hasNewAvatar
                    ? FileImage(File(p.localAvatarPath!)) as ImageProvider
                    : const AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B2323),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTile(
    String label,
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 10),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
