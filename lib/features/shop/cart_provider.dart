import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';
import 'package:static_touch/shared/repositories/order_repository.dart';

class CartProvider extends BaseProvider {
  final OrderRepository _repo = locator<OrderRepository>();
  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  void addToCart(ProductModel product) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(
        CartItemModel(
          productId: product.id,
          title: product.title,
          coverUrl: product.coverUrl,
          price: double.tryParse(product.price) ?? 0.0,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    final item = _items.firstWhere((e) => e.productId == productId);
    item.quantity += delta;
    if (item.quantity <= 0) {
      _items.remove(item);
    }
    notifyListeners();
  }

  void toggleSelect(String productId) {
    final item = _items.firstWhere((e) => e.productId == productId);
    item.isSelected = !item.isSelected;
    notifyListeners();
  }

  void toggleSelectAll(bool selectAll) {
    for (var item in _items) {
      item.isSelected = selectAll;
    }
    notifyListeners();
  }

  bool get isAllSelected => _items.isNotEmpty && _items.every((item) => item.isSelected);
  int get selectedCount => _items.where((e) => e.isSelected).fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      _items.where((e) => e.isSelected).fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  int get totalUniqueItems => _items.length;

  Future<bool> checkout() async {
    final selectedItems = _items.where((e) => e.isSelected).toList();
    if (selectedItems.isEmpty) {
      setError("请先选择要结算的商品");
      return false;
    }
    setLoading(true);
    final result = await _repo.submitOrder(selectedItems, totalPrice);
    setLoading(false);
    if (result.status) {
      // 👇 核心修复：延迟 300 毫秒清空购物车，让 UI 路由动画能顺滑走完，彻底告别卡死！
      Future.delayed(const Duration(milliseconds: 300), () {
        _items.removeWhere((e) => e.isSelected);
        notifyListeners();
      });
      return true;
    } else {
      setError(result.message);
      return false;
    }
  }
}
