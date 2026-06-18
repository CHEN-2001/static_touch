import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/theme/app_colors.dart';

import 'shop_provider.dart';
import 'cart_provider.dart';
import 'widgets/shop_widgets.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 监听商城商品数据的变化
    final p = context.watch<ShopProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '自营商城',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          // 购物车入口及角标
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
                onPressed: () => context.push(AppRoutes.cart),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cartP, _) {
                    // 如果购物车为空，隐藏角标
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
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. 顶部分类 Tabs
          ShopCategoryTabs(categories: p.categories, selectedId: p.selectedCategoryId, onSelect: p.selectCategory),
          const SizedBox(height: 10),

          // 2. 商品网格列表
          Expanded(
            child: p.isLoading && p.displayProducts.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : p.displayProducts.isEmpty
                ? const Center(
                    child: Text("暂无商品", style: TextStyle(color: Colors.grey)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75, // 控制图片和文字比例
                    ),
                    itemCount: p.displayProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCardItem(product: p.displayProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
