import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';
import 'package:static_touch/shared/repositories/order_repository.dart';

class OrderProvider extends BaseProvider {
  final OrderRepository _repo = locator<OrderRepository>();
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> fetchOrders(int? status) async {
    setLoading(true);
    final result = await _repo.fetchOrders(status);
    if (result.status && result.data != null) {
      _orders = result.data!;
    } else {
      setError(result.message);
    }
    setLoading(false);
  }

  Future<bool> confirmOrderReceipt(String orderId) async {
    setLoading(true);
    final result = await _repo.confirmReceipt(orderId);
    setLoading(false);
    if (result.status) {
      // 👇 核心修复：延迟更新状态，让订单详情页可以丝滑退出
      Future.delayed(const Duration(milliseconds: 300), () {
        final idx = _orders.indexWhere((o) => o.orderId == orderId);
        if (idx >= 0) {
          _orders[idx].status = 3;
          notifyListeners();
        }
      });
      return true;
    }
    return false;
  }

  Future<bool> submitProductReview({
    required String orderId,
    required String productId,
    required double rating,
    required String content,
  }) async {
    setLoading(true);
    final result = await _repo.submitReview(orderId: orderId, productId: productId, rating: rating, content: content);
    setLoading(false);
    if (result.status) {
      final oIdx = _orders.indexWhere((o) => o.orderId == orderId);
      if (oIdx >= 0) {
        final iIdx = _orders[oIdx].items.indexWhere((i) => i.productId == productId);
        if (iIdx >= 0) {
          _orders[oIdx].items[iIdx].isCommented = true;
          notifyListeners();
        }
      }
      return true;
    }
    return false;
  }
}
