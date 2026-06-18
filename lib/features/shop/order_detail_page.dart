import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';
import 'package:static_touch/shared/models/shop/shop_model.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
// 必须用绝对路径
import 'package:static_touch/features/shop/order_provider.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  String _getStatusString(int status) {
    if (status == 0) return '待付款';
    if (status == 1) return '待发货';
    if (status == 2) return '已发货/待收货';
    return '已完成';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '订单详情',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 状态头部
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusString(order.status),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('订单编号: ${order.orderNo}', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 商品明细卡片
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('商品清单', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Divider(height: 24),

                  // 👇 核心修复：已经将 ...map 替换为了 for 循环，彻底解决卡死问题
                  for (final item in order.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.cardBorder,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              item.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '¥${item.price}  x${item.quantity}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 操作操作栏：查看商品 / 去评价
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // 组装简易 ProductModel 实体跳回商品详情看对应的商品
                                  final mockProduct = ProductModel(
                                    id: item.productId,
                                    categoryId: '',
                                    title: item.title,
                                    coverUrl: item.coverUrl,
                                    price: item.price.toString(),
                                    originalPrice: '',
                                    description: '暂无详情描述',
                                    reviews: [],
                                  );
                                  context.push(AppRoutes.shopDetail, extra: mockProduct);
                                },
                                child: const Text('查看商品', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ),
                              // 只有当状态为 3 (已签收完成) 且未评论时才可以评价
                              if (order.status == 3)
                                ElevatedButton(
                                  onPressed: item.isCommented
                                      ? null
                                      : () => context.push(
                                          AppRoutes.writeComment,
                                          extra: {'orderId': order.orderId, 'item': item},
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.zenGold,
                                    disabledBackgroundColor: Colors.grey[200],
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    item.isCommented ? '已评价' : '写评价',
                                    style: TextStyle(
                                      color: item.isCommented ? Colors.grey : Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  // 👆 循环结束
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 价格流水明细
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('实付款金额', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '¥${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 底部工具条，若处于待收货(2)状态，可点击签收
      bottomNavigationBar: order.status == 2
          ? Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: MediaQuery.paddingOf(context).bottom + 10),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: p.isLoading
                    ? null
                    : () async {
                        final ok = await p.confirmOrderReceipt(order.orderId);
                        if (ok && context.mounted) {
                          context.showAppToast(message: "商品已签收，功德圆满", type: AppToastType.success);
                          context.pop();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  fixedSize: const Size.fromHeight(46),
                  elevation: 0,
                ),
                child: const Text(
                  '确认签收',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : null,
    );
  }
}
