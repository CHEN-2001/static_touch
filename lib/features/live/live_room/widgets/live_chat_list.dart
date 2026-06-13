import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../live_detail_provider.dart';
import 'package:static_touch/shared/models/live/live_chat_message_model.dart';

class LiveChatList extends StatefulWidget {
  const LiveChatList({super.key});

  @override
  State<LiveChatList> createState() => _LiveChatListState();
}

class _LiveChatListState extends State<LiveChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听 Provider 中的 danmuList
    return Consumer<LiveDetailProvider>(
      builder: (context, provider, child) {
        final danmus = provider.danmuList;

        // 列表更新后，延迟一帧平滑滚动到底部
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });

        return Container(
          // 增加底部黑色渐变，防止弹幕文字看不清
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.4)],
            ),
          ),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 80, 16), // 右侧流出空隙防遮挡点赞等操作
            itemCount: danmus.length,
            itemBuilder: (context, index) {
              final msg = danmus[index];

              // --- 渲染系统公告 ---
              if (msg.type == 'SYSTEM') {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(msg.content, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 13)),
                );
              }

              // --- 渲染进场消息 ---
              if (msg.type == 'ENTER') {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${msg.senderName ?? '匿名用户'} ${msg.content}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              }

              // --- 渲染常规聊天消息 ---
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, height: 1.4),
                    children: [
                      TextSpan(
                        text: '${msg.senderName ?? '观众'}: ',
                        style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: msg.content,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
