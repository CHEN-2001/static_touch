import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/shop_repository.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/core/result/result_model.dart';

class ShopProvider extends BaseProvider {
  final ShopRepository _repo = locator<ShopRepository>();

  List<ShopCategoryModel> _categories = [];
  List<ShopCategoryModel> get categories => _categories;

  List<ProductModel> _allProducts = [];

  String _selectedCategoryId = '0'; // 默认选中'全部'
  String get selectedCategoryId => _selectedCategoryId;

  // 根据当前选中分类过滤展示商品
  List<ProductModel> get displayProducts {
    if (_selectedCategoryId == '0') return _allProducts;
    return _allProducts.where((p) => p.categoryId == _selectedCategoryId).toList();
  }

  Future<void> initData() async {
    setLoading(true);
    clearError();

    // 并行获取分类和商品
    final results = await Future.wait([_repo.fetchCategories(), _repo.fetchProducts()]);

    final catRes = results[0] as ResultEntity<List<ShopCategoryModel>>;
    final prodRes = results[1] as ResultEntity<List<ProductModel>>;

    if (catRes.status && catRes.data != null) {
      _categories = catRes.data!;
      if (_categories.isNotEmpty) _selectedCategoryId = _categories.first.id;
    } else {
      setError(catRes.message);
    }

    if (prodRes.status && prodRes.data != null) {
      _allProducts = prodRes.data!;
    }

    setLoading(false);
  }

  void selectCategory(String id) {
    if (_selectedCategoryId != id) {
      _selectedCategoryId = id;
      notifyListeners();
    }
  }
}
