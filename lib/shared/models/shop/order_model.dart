class CartItemModel {
  final String productId;
  final String title;
  final String coverUrl;
  final double price;
  int quantity;
  bool isSelected;
  bool isCommented; // 👈 新增：标记该笔订单下的商品是否已写过评论

  CartItemModel({
    required this.productId,
    required this.title,
    required this.coverUrl,
    required this.price,
    this.quantity = 1,
    this.isSelected = true,
    this.isCommented = false, // 默认未评论
  });
}

class OrderModel {
  final String orderId;
  final String orderNo;
  final double totalAmount;
  int status;
  final String createTime;
  final List<CartItemModel> items;

  OrderModel({
    required this.orderId,
    required this.orderNo,
    required this.totalAmount,
    required this.status,
    required this.createTime,
    required this.items,
  });
}
