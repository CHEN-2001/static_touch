import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'notice_provider.dart';
import 'widgets/notice_widgets.dart'; // 🚀 统一引入新的聚合组件库

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeProvider>().fetchNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NoticeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF4A2B11),
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          '消息通知',
          style: TextStyle(
            color: Color(0xFF4A2B11),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          // 🚀 智能判断：如果有未读消息才显示“一键已读”
          if (p.displayNotices.any((e) => !e.isRead))
            TextButton(
              onPressed: p.isLoading ? null : p.markAllAsRead,
              child: p.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFD4AF37),
                      ),
                    )
                  : const Text(
                      '一键已读',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
      body: Column(
        children: [
          const NoticeTabs(),
          const Divider(height: 1, color: Color(0x1A000000)),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF8B2323),
              backgroundColor: Colors.white,
              onRefresh: () async => await p.fetchNotices(),
              child: p.isLoading && p.displayNotices.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8B2323),
                      ),
                    )
                  : p.displayNotices.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "暂无消息记录",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: p.displayNotices.length,
                      itemBuilder: (context, index) =>
                          NoticeItemTile(notice: p.displayNotices[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
