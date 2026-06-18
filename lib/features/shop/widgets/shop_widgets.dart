import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/routes/app_router.dart';

// ================= 分类栏组件 =================
class ShopCategoryTabs extends StatelessWidget {
  final List<ShopCategoryModel> categories;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const ShopCategoryTabs({super.key, required this.categories, required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.id == selectedId;
          return GestureDetector(
            onTap: () => onSelect(cat.id),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cat.name,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: isSelected ? 20 : 0,
                  color: AppColors.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= 商品卡片组件 (瀑布流网格形态) =================
class ProductCardItem extends StatelessWidget {
  final ProductModel product;

  const ProductCardItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.shopDetail, extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF9F6F0),
                child: Image.network(
                  product.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.shopping_bag, color: AppColors.cardBorder, size: 40)),
                ),
              ),
            ),
            // 文字信息
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '¥',
                        style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.price,
                        style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.originalPrice,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
