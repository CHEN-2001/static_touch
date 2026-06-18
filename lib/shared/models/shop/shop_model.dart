// 1. 商品分类实体
class ShopCategoryModel {
  final String id;
  final String name;

  ShopCategoryModel({required this.id, required this.name});
}

// 2. 新增：商品评论实体
class ProductReviewModel {
  final String id;
  final String userName;
  final String avatarUrl;
  final double rating;
  final String content;
  final String createTime;

  ProductReviewModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.rating,
    required this.content,
    required this.createTime,
  });
}

// 3. 自营商品实体（包含评论列表）
class ProductModel {
  final String id;
  final String categoryId;
  final String title;
  final String coverUrl;
  final String price;
  final String originalPrice;
  final String description;
  final List<ProductReviewModel> reviews;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.coverUrl,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.reviews,
  });
}
