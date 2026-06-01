import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/nfc_repository.dart';
import 'package:static_touch/shared/models/nfc/nfc_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class NfcProvider extends BaseProvider {
  final NfcRepository _repo = locator<NfcRepository>();

  NfcDeviceModel? _device;
  NfcDeviceModel? get device => _device;

  Future<void> fetchDevice() async {
    setLoading(true);
    final result = await _repo.fetchDeviceInfo();
    if (result.status && result.data != null) {
      _device = result.data;
    } else {
      _device = NfcDeviceModel.unbound(); // 如果没获取到，视为未绑定
    }
    setLoading(false);
  }

  // 🚀 补齐交互：完整的解除绑定流程
  Future<void> unbindDevice(BuildContext context) async {
    if (_device == null || !_device!.isBound) return;

    // 1. 二次确认弹窗
    bool? confirm = await context.showAppDialog(
      title: "解除绑定",
      content: "确定要解除当前音饰的绑定吗？解除后将无法使用一键进入功能。",
      confirmText: "解除",
      cancelText: "再想想",
    );

    if (confirm != true) return;

    // 2. 发起请求
    setLoading(true);
    final result = await _repo.unbindDevice(_device!.id);
    setLoading(false);

    // 3. 结果处理
    if (result.status) {
      _device = NfcDeviceModel.unbound();
      if (context.mounted) {
        context.showAppToast(message: "已解除绑定", type: AppToastType.success);
      }
      notifyListeners();
    } else {
      setError(result.message);
    }
  }

  // 🚀 补齐交互：模拟重新绑定流程
  Future<void> simulateRebind(BuildContext context) async {
    // 模拟调起 NFC 感应（实际开发中这里调 NfcService.startReading）
    context.showAppToast(
      message: "请将新的音饰贴近手机感应区...",
      type: AppToastType.warning,
    );

    setLoading(true);
    // 模拟读到了新 ID 并提交给后端
    final result = await _repo.bindDevice(
      "SN_NEW_${DateTime.now().millisecondsSinceEpoch}",
    );
    setLoading(false);

    if (result.status && result.data != null) {
      _device = result.data;
      if (context.mounted) {
        context.showAppToast(message: "重新绑定成功！", type: AppToastType.success);
      }
      notifyListeners();
    } else {
      setError(result.message);
    }
  }
}
