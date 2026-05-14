import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'vip_provider.dart';
import 'widgets/vip_widgets.dart';

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VipProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<VipProvider>();
    final user = context.watch<UserStateProvider>().user; // 获取全局用户数据

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "会员中心",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: p.isLoading && p.plans.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 120), // 给底部支付按钮留出空间
                  children: [
                    VipHeaderCard(user: user, status: p.status),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "选择套餐",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                      ),
                    ),

                    // 左右滑动的套餐列表
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: p.plans.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final plan = p.plans[index];
                          return VipPlanCard(
                            plan: plan,
                            isSelected: p.selectedPlanId == plan.id,
                            onTap: () => p.selectPlan(plan.id),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 特权展示占位
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "会员特权",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2B11)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "1. 畅听全部回放内容\n2. 专属免广告体验\n3. 尊贵金色身份标识",
                          style: TextStyle(color: Colors.grey, height: 1.8),
                        ),
                      ),
                    ),
                  ],
                ),

                // 底部固定支付按钮
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: p.isLoading ? null : () => p.purchase(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A2B11),
                        fixedSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: p.isLoading
                          ? const CircularProgressIndicator(color: Color(0xFFD4AF37))
                          : const Text(
                              "立即开通",
                              style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
