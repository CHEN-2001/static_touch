import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:static_touch/shared/providers/user_state_provider.dart';
import 'widgets/mine_widgets.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});
  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    await context.read<UserStateProvider>().initData(isSilent: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfffdfbf7),
      body: RefreshIndicator(
        color: const Color(0xFF8B2323),
        backgroundColor: Colors.white,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                const MineHeader(),
                const SizedBox(height: 20),
                const MineMenuList(),
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
