import 'package:flutter/material.dart';
import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/vip_repository.dart';
import 'package:static_touch/shared/models/vip/vip_model.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class VipProvider extends BaseProvider {
  final VipRepository _repo = locator<VipRepository>();

  VipStatusModel? _status;
  VipStatusModel? get status => _status;

  List<VipPlanModel> _plans = [];
  List<VipPlanModel> get plans => _plans;

  // 当前选中的套餐
  String? _selectedPlanId;
  String? get selectedPlanId => _selectedPlanId;

  Future<void> loadData() async {
    setLoading(true);
    final statusRes = await _repo.fetchStatus();
    final plansRes = await _repo.fetchPlans();

    if (statusRes.status) _status = statusRes.data;
    if (plansRes.status) {
      _plans = plansRes.data ?? [];
      if (_plans.isNotEmpty) _selectedPlanId = _plans.first.id; // 默认选中第一个
    }
    setLoading(false);
  }

  void selectPlan(String id) {
    _selectedPlanId = id;
    notifyListeners();
  }

  Future<void> purchase(BuildContext context) async {
    if (_selectedPlanId == null) return;

    setLoading(true);
    final res = await _repo.purchasePlan(_selectedPlanId!);
    setLoading(false);

    if (!context.mounted) return;

    if (res.status && res.data != null) {
      _status = res.data; // 更新本地状态为已开通
      context.showAppToast(message: "开通成功！尊享特权已生效", type: AppToastType.success);
      notifyListeners();
    } else {
      setError("支付失败，请重试");
    }
  }
}
