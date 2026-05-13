import 'package:static_touch/locator.dart';
import 'package:static_touch/features/auth/auth_repository.dart';
import 'package:static_touch/shared/providers/base_provider.dart'; // 🚀 引入基类

// 🚀 继承 BaseProvider，自动获得 setLoading, setError 和 isLoading 属性
class LoginProvider extends BaseProvider {
  final AuthRepository _repo = locator<AuthRepository>();

  bool _isAgreed = false;
  bool _isAccountLogin = true;

  bool get isAgreed => _isAgreed;
  bool get isAccountLogin => _isAccountLogin;

  void toggleAgreement() {
    _isAgreed = !_isAgreed;
    notifyListeners();
  }

  void switchLoginMethod() {
    _isAccountLogin = !_isAccountLogin;
    notifyListeners();
  }

  // 🚀 纯粹的业务逻辑：返回 bool。UI 层不需要知道具体的报错信息，因为 setError 会自动弹红色的 Toast
  Future<bool> login(String account, String password) async {
    // 1. 拦截空值校验
    if (account.isEmpty || password.isEmpty) {
      setError("账号或密码不能为空");
      return false;
    }

    setLoading(true);
    clearError();

    // 2. 调用仓库发起请求
    final result = await _repo.loginWithPassword(account, password);

    setLoading(false);

    // 3. 结果分发
    if (result.status) {
      return true;
    } else {
      setError(result.message); // BaseProvider 底层会自动拦截并触发全局 Toast
      return false;
    }
  }

  Future<bool> loginByNfc(String id) async {
    setLoading(true);
    clearError();

    final result = await _repo.loginByNfc(id);

    setLoading(false);

    if (result.status) {
      return true;
    } else {
      setError(result.message);
      return false;
    }
  }
}
