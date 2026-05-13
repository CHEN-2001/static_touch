import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/nfc/nfc_model.dart';

class NfcRepository {
  final HttpClient _client;
  NfcRepository(this._client);

  static const bool isMock = true;

  // 获取当前绑定的 NFC 信息
  Future<ResultEntity<NfcDeviceModel>> fetchDeviceInfo() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: NfcDeviceModel(
        id: 'SN2023030312348888',
        name: '我的专属静心音饰',
        bindDate: '2026-03-01',
      ),
    );
  }

  // 解除绑定
  Future<ResultEntity> unbindDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ResultEntity(status: true, message: '解除绑定成功');
  }

  // 重新绑定 (模拟写入)
  Future<ResultEntity<NfcDeviceModel>> bindDevice(String newId) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // 模拟感应写入时间
    return ResultEntity(
      status: true,
      message: '绑定成功',
      data: NfcDeviceModel(id: newId, name: '新静心音饰', bindDate: '刚刚'),
    );
  }
}
