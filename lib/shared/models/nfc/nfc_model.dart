class NfcDeviceModel {
  final String id;
  final String name;
  final String bindDate;
  final bool isBound;

  NfcDeviceModel({
    required this.id,
    required this.name,
    required this.bindDate,
    this.isBound = true,
  });

  // 模拟一个解除绑定后的空状态
  factory NfcDeviceModel.unbound() {
    return NfcDeviceModel(id: '', name: '未绑定设备', bindDate: '', isBound: false);
  }
}
