import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/live_tabs.dart';
import 'widgets/live_list.dart';
import 'package:static_touch/widgets/scale_button.dart'; // 引入之前的缩放按钮

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7), // 使用图片中的米色背景
      body: SafeArea(
        // 自动处理顶部和底部状态栏/Home Indicator
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 顶部标题
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Text(
                    '直播',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B2323)),
                  ),
                ),

                // 2. 顶部 Tab 切换
                const LiveTabs(),
                const SizedBox(height: 16),

                // 3. 直播列表 (必须用 Expanded，防止 Column 内部报错)
                const Expanded(child: LiveList()),
              ],
            ),

            // 4. 🚀 底部悬浮按钮 (不随页面滚动)
            Positioned(
              bottom: 24, // 距离底部高度，适配全面屏 Home Indicator
              left: 0,
              right: 0,
              child: const StartLiveButton(), // 抽离为单独的 Stateless Widget
            ),
          ],
        ),
      ),
    );
  }
}

// 🚀 “+开启直播”悬浮按钮组件
class StartLiveButton extends StatelessWidget {
  const StartLiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleButton(
        // 💡 这里执行跳转逻辑
        onTap: () {
          // 1. 如果有业务逻辑（如重置 Provider 状态），可以先调用

          // 2. 执行路由跳转到准备页
          // 使用 push 是因为准备页通常有一个“关闭”按钮，点击后可以返回列表
          context.push('/livePrepare');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8B2323),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: const Text(
            '+ 开启直播',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
