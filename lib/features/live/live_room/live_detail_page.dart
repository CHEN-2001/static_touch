import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:static_touch/shared/providers/live_state_provider.dart';
import 'live_detail_provider.dart';
import 'widgets/live_player.dart';
import 'widgets/live_actions.dart';
import 'widgets/live_chat_list.dart';

class LiveDetailPage extends StatefulWidget {
  final String liveId;
  const LiveDetailPage({super.key, required this.liveId});
  @override
  State<LiveDetailPage> createState() => _LiveDetailPageState();
}

class _LiveDetailPageState extends State<LiveDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveDetailProvider>().enterRoom(widget.liveId);
      context.read<LiveStateProvider>().activateLiveState(liveId: widget.liveId, isAnchor: false);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      context.read<LiveDetailProvider>().sendDanmu(text);
      _inputController.clear();
      _focusNode.unfocus();
    }
  }

  Future<void> _handleExit() async {
    await context.read<LiveStateProvider>().leaveOrEndLive();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LiveDetailProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: _handleExit,
              ),
            ),
            p.isLoading
                ? const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
                  )
                : const LivePlayer(),
            const LiveActions(),
            const Expanded(child: LiveChatList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomInset > 0 ? 10 : 20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: const Color(0xFFD4AF37),
                decoration: const InputDecoration(
                  hintText: '说点什么...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleSend,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                '发送',
                style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
