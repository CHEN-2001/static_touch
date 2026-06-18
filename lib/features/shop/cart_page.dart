import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '购物车',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: p.items.isEmpty
          ? const Center(
              child: Text("您的缘分背篓空空如也~", style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: p.items.length,
              itemBuilder: (context, index) {
                final item = p.items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isSelected,
                        activeColor: AppColors.primary,
                        shape: const CircleBorder(),
                        onChanged: (_) => p.toggleSelect(item.productId),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.cardBorder),
                        clipBehavior: Clip.antiAlias,
                        // 👇 修复：加入 errorBuilder，即使图片链接失效也不会卡崩应用
                        child: Image.network(
                          item.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '¥${item.price}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                                      onPressed: () => p.updateQuantity(item.productId, -1),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                                      onPressed: () => p.updateQuantity(item.productId, 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomSheet: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.paddingOf(context).bottom + 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Checkbox(
              value: p.isAllSelected,
              activeColor: AppColors.primary,
              shape: const CircleBorder(),
              onChanged: (val) => p.toggleSelectAll(val ?? false),
            ),
            const Text('全选', style: TextStyle(fontSize: 14)),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('合计: ', style: TextStyle(fontSize: 14)),
                    Text(
                      '¥${p.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text('已选 ${p.selectedCount} 件', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: p.isLoading
                  ? null
                  : () async {
                      final success = await p.checkout();
                      if (success && context.mounted) {
                        context.showAppToast(message: "结算成功，缘分已结", type: AppToastType.success);
                        context.pop();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: p.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      '去结算',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
