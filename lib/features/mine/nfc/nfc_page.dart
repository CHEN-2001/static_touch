import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'nfc_provider.dart';
import 'widgets/nfc_widgets.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NfcProvider>().fetchDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color themeBrown = Color(0xFF4A2B11);
    const Color themeRed = Color(0xFF8B2323);
    const Color themeBg = Color(0xFFFDFBF7);

    final p = context.watch<NfcProvider>();
    final device = p.device;

    return Scaffold(
      backgroundColor: themeBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: themeBrown, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '我的NFC',
          style: TextStyle(color: themeBrown, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      // 直接判断 device 是否为空，避免第 1 帧的 Null 崩溃
      body: device == null
          ? const Center(child: CircularProgressIndicator(color: themeRed))
          : Column(
              children: [
                // 顶部展示卡片 (Dart 会自动推断此时 device 不为空，所以去掉了之前的 !)
                NfcHeaderCard(device: device),

                const SizedBox(height: 10),

                // 功能菜单 (传入是否绑定的状态)
                NfcActionList(isBound: device.isBound),

                const Spacer(),

                // 底部一键进入按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: p.isLoading
                          ? null
                          : () {
                              // 加入逻辑校验：未绑定不准进！
                              if (!device.isBound) {
                                context.showAppToast(message: "请先绑定您的 NFC 设备", type: AppToastType.warning);
                                return;
                              }
                              // 执行路由跳转，进入直播详情页
                              context.push(AppRoutes.liveDetail);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: device.isBound ? themeRed : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        elevation: device.isBound ? 2 : 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: p.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              '一键进入直播',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 8),
                  child: Text('绑定音饰后，触碰感应位即可快速修行', style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
                ),
              ],
            ),
    );
  }
}
