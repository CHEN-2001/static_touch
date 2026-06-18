import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/models/shop/order_model.dart';
import 'package:static_touch/shared/theme/app_colors.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';
// 必须用绝对路径
import 'package:static_touch/features/shop/order_provider.dart';

class WriteCommentPage extends StatefulWidget {
  final String orderId;
  final CartItemModel item;

  const WriteCommentPage({super.key, required this.orderId, required this.item});

  @override
  State<WriteCommentPage> createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
  double _rating = 5.0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.read<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '发表评价',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品信息概要
              Row(
                children: [
                  Image.network(widget.item.coverUrl, width: 45, height: 45, fit: BoxFit.cover),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // 星星评分条
              const Text('评分归类', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.zenGold,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // 输入框
              const Text('评语心得', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: '写下你的结缘心得，给其他同修作参考吧...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  fillColor: AppColors.background,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_commentController.text.trim().isEmpty) {
                    context.showAppToast(message: "请输入评语文案", type: AppToastType.info);
                    return;
                  }
                  final ok = await p.submitProductReview(
                    orderId: widget.orderId,
                    productId: widget.item.productId,
                    rating: _rating,
                    content: _commentController.text.trim(),
                  );
                  if (ok && context.mounted) {
                    context.showAppToast(message: "评价成功", type: AppToastType.success);
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 46),
                  elevation: 0,
                ),
                child: const Text(
                  '提交评价',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
