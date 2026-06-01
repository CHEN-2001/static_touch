import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:static_touch/core/result/result_model.dart';

class NfcService {
  static bool _isReading = false;

  // 检查NFC状态
  static Future<ResultEntity> checkStatus() async {
    final status = await NfcManager.instance.checkAvailability();
    String message;
    switch (status) {
      case NfcAvailability.enabled:
        message = "NFC 已就绪";
        break;
      case NfcAvailability.disabled:
        message = "NFC 功能未开启";
        break;
      case NfcAvailability.unsupported:
        message = "不支持 NFC";
        break;
    }
    return ResultEntity(status: status == NfcAvailability.enabled, message: message);
  }

  // ID 读取
  static void startReading({required Function(String id) onSuccess, Function(String error)? onError}) {
    _isReading = false;
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      noPlatformSoundsAndroid: true,
      onDiscovered: (NfcTag tag) async {
        if (_isReading) return;
        try {
          String? finalId;
          final ndef = NdefAndroid.from(tag);
          if (ndef != null) {
            _isReading = true;
            finalId = _parseId(ndef.tag.id);
          } else {
            final tech = NfcTagAndroid.from(tag);
            if (tech != null) {
              _isReading = true;
              finalId = _parseId(tech.id);
            }
          }
          if (finalId != null) {
            onSuccess(finalId);
          }
        } catch (e) {
          _isReading = false;
          if (onError != null) onError("ID解析失败");
        }
      },
    );
  }

  /// 停止扫描，完成生命周期闭环
  static Future<void> stopReading() async {
    _isReading = false;
    await NfcManager.instance.stopSession();
  }

  /// 内部：将 ID 字节转为十六进制字符串
  static String _parseId(Uint8List idBytes) {
    return idBytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join('').toUpperCase();
  }
}
