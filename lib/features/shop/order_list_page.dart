import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/routes/app_router.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
// 必须用绝对路径，否则会报 Provider 找不到导致假死！
import 'package:static_touch/features/shop/order_provider.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders(null); // 默认查全部
    });
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return '待付款';
      case 1:
        return '待发货';
      case 2:
        return '已发货/待收货';
      case 3:
        return '已完成';
      default:
        return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            '我的订单',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: (index) {
              int? status = index == 0 ? null : index - 1;
              context.read<OrderProvider>().fetchOrders(status);
            },
            tabs: const [
              Tab(text: '全部'),
              Tab(text: '待付款'),
              Tab(text: '待发货'),
              Tab(text: '待收货'),
              Tab(text: '已完成'),
            ],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, p, _) {
            if (p.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            if (p.orders.isEmpty) {
              return const Center(
                child: Text("暂无订单", style: TextStyle(color: Colors.grey)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: p.orders.length,
              itemBuilder: (context, index) {
                final order = p.orders[index];

                // 核心修复点：加入 GestureDetector 实现点击卡片跳转到详情页！
                return GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.orderDetail, extra: order);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('单号: ${order.orderNo}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(
                              _getStatusText(order.status),
                              style: const TextStyle(
                                color: AppColors.zenGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.background),

                        // 不会导致卡死的 for 循环写法
                        for (final item in order.items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
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
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('¥${item.price}', style: const TextStyle(color: AppColors.primary)),
                                          Text(
                                            'x${item.quantity}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(height: 24, color: AppColors.background),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '实付款: ¥${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
