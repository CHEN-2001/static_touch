import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';

class OrderRepository {
  final HttpClient _client;
  OrderRepository(this._client);

  Future<ResultEntity<bool>> submitOrder(List<CartItemModel> items, double totalAmount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ResultEntity(status: true, message: '订单提交成功', data: true);
  }

  Future<ResultEntity<List<OrderModel>>> fetchOrders(int? status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    List<OrderModel> mockOrders = [
      OrderModel(
        orderId: 'o1',
        orderNo: 'SN202606150001',
        totalAmount: 299.0,
        status: 2, // 待收货/已发货状态
        createTime: '2026-06-15 10:30',
        items: [
          CartItemModel(
            productId: 'p1',
            title: '尼泊尔手工满月颂钵',
            coverUrl: 'https://images.unsplash.com/photo-1613076842589-983b6329a770?w=400',
            price: 299.0,
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        orderId: 'o2',
        orderNo: 'SN202606120088',
        totalAmount: 128.0,
        status: 3, // 已完成（已签收状态，可点击评价）
        createTime: '2026-06-12 14:20',
        items: [
          CartItemModel(
            productId: 'p2',
            title: '天然荞麦壳禅修蒲团',
            coverUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
            price: 128.0,
            quantity: 1,
            isCommented: false,
          ),
        ],
      ),
    ];
    if (status != null) {
      mockOrders = mockOrders.where((e) => e.status == status).toList();
    }
    return ResultEntity(status: true, message: '获取成功', data: mockOrders);
  }

  // 模拟确认签收
  Future<ResultEntity<bool>> confirmReceipt(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ResultEntity(status: true, message: '签收成功', data: true);
  }

  // 模拟提交评论
  Future<ResultEntity<bool>> submitReview({
    required String orderId,
    required String productId,
    required double rating,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ResultEntity(status: true, message: '评论成功', data: true);
  }
}
