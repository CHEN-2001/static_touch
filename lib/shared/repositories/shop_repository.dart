import 'package:static_touch/core/network/http_client.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';

class ShopRepository {
  final HttpClient _client;
  ShopRepository(this._client);

  static const bool isMock = true;

  Future<ResultEntity<List<ShopCategoryModel>>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: [
        ShopCategoryModel(id: '0', name: '全部'),
        ShopCategoryModel(id: '1', name: '颂钵音疗'),
        ShopCategoryModel(id: '2', name: '冥想坐垫'),
      ],
    );
  }

  Future<ResultEntity<List<ProductModel>>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ResultEntity(
      status: true,
      message: '获取成功',
      data: [
        ProductModel(
          id: 'p1',
          categoryId: '1',
          title: '尼泊尔手工满月颂钵',
          coverUrl: 'https://images.unsplash.com/photo-1613076842589-983b6329a770?w=400',
          price: '299',
          originalPrice: '¥399',
          description: '采用喜马拉雅山脉原矿七金，纯手工锻打。声音空灵悠远，适合冥想前清理磁场，帮助快速进入静心状态。',
          reviews: [
            ProductReviewModel(
              id: 'r1',
              userName: '妙音居士',
              avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
              rating: 5.0,
              content: '钵音浑厚悠长，敲击一下余音缭绕，打坐入静快了很多，包装也很精致。',
              createTime: '2026-06-12',
            ),
            ProductReviewModel(
              id: 'r2',
              userName: '行者云心',
              avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              rating: 4.5,
              content: '手工痕迹明显，声音确实比普通机械钵好听很多，用来调理身心很合适。',
              createTime: '2026-06-14',
            ),
          ],
        ),
        ProductModel(
          id: 'p2',
          categoryId: '2',
          title: '天然荞麦壳禅修蒲团',
          coverUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
          price: '128',
          originalPrice: '¥168',
          description: '透气棉麻材质，内部填充高温杀菌天然荞麦壳。符合人体工学设计，有效支撑脊椎，久坐不累。',
          reviews: [
            ProductReviewModel(
              id: 'r3',
              userName: '正念阿白',
              avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
              rating: 5.0,
              content: '软硬度正好，高度对盘腿支撑力很足，麻布面料摸着很质朴。',
              createTime: '2026-06-08',
            ),
          ],
        ),
      ],
    );
  }
}
