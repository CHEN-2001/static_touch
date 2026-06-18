import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'package:static_touch/features/shop/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              style: IconButton.styleFrom(backgroundColor: Colors.black26),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.image, size: 80, color: AppColors.cardBorder)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 价格信息
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '¥',
                        style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.price,
                        style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      if (product.originalPrice.isNotEmpty)
                        Text(
                          product.originalPrice,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 24),

                  // 商品详情描述
                  const Row(
                    children: [
                      Icon(Icons.format_quote, color: AppColors.zenGold, size: 20),
                      SizedBox(width: 6),
                      Text(
                        '商品详情',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(product.description, style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.8)),
                  const SizedBox(height: 24),

                  // 核心扩充：用户评价列表板块
                  Row(
                    children: [
                      const Icon(Icons.comment_bank_outlined, color: AppColors.zenGold, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '同修评价 (${product.reviews.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (product.reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('暂无评价，买下签收后快来占领沙发吧~', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: product.reviews.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, idx) {
                        final rev = product.reviews[idx];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 14, backgroundImage: NetworkImage(rev.avatarUrl)),
                                const SizedBox(width: 10),
                                Text(
                                  rev.userName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: i < rev.rating ? AppColors.zenGold : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(rev.content, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
                            const SizedBox(height: 4),
                            Text(rev.createTime, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: MediaQuery.paddingOf(context).bottom + 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary, size: 28),
                  onPressed: () => context.push(AppRoutes.cart),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Consumer<CartProvider>(
                    builder: (context, cartP, _) {
                      if (cartP.totalUniqueItems == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Text(
                          '${cartP.totalUniqueItems}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addToCart(product);
                  context.showAppToast(message: "已加入结缘清单", type: AppToastType.success);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zenGold.withOpacity(0.15),
                  foregroundColor: AppColors.zenGold,
                  elevation: 0,
                  fixedSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('加入清单', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addToCart(product);
                  context.push(AppRoutes.cart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  fixedSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('立即请购', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
