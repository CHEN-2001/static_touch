import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfileEditProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        title: const Text(
          "资料修改",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          TextButton(
            onPressed: p.isLoading
                ? null
                : () async {
                    final success = await p.saveProfile(nickName: _nameCtrl.text, dailyQuote: _quoteCtrl.text);
                    if (success && mounted) {
                      context.showAppToast(message: "修改成功", type: AppToastType.success);
                      Navigator.pop(context);
                    }
                  },
            child: Text(
              p.isLoading ? "提交中" : "保存",
              style: const TextStyle(color: Color(0xFF8B2323), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildInputTile("昵称", _nameCtrl, "请输入您的昵称"),
          const SizedBox(height: 20),
          _buildInputTile("个人签名", _quoteCtrl, "写下此时此刻的心境...", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildInputTile(String label, TextEditingController ctrl, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
