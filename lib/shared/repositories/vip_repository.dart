import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/vip/vip_model.dart';

class VipRepository {
  final HttpClient _client;
  VipRepository(this._client);

  static const bool isMock = true;

  // 获取会员状态
  Future<ResultEntity<VipStatusModel>> fetchStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: VipStatusModel(isVip: false, expireDate: '尚未开通'),
    );
  }

  // 获取套餐列表
  Future<ResultEntity<List<VipPlanModel>>> fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: [
        VipPlanModel(id: '1', title: '连续包月', price: '18', originalPrice: '¥30', description: '首月特惠'),
        VipPlanModel(id: '2', title: '季卡', price: '58', originalPrice: '¥90', description: '折合¥19/月'),
        VipPlanModel(id: '3', title: '年卡', price: '168', originalPrice: '¥360', description: '超值特惠'),
      ],
    );
  }

  // 模拟支付开通
  Future<ResultEntity<VipStatusModel>> purchasePlan(String planId) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // 模拟支付调用
    final expire = DateTime.now().add(const Duration(days: 30));
    return ResultEntity(
      status: true,
      message: '支付成功',
      data: VipStatusModel(
        isVip: true,
        expireDate:
            "${expire.year}-${expire.month.toString().padLeft(2, '0')}-${expire.day.toString().padLeft(2, '0')} 到期",
      ),
    );
  }
}
