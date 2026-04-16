import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'collections_provider.dart';
import 'widgets/collection_item_tile.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionsProvider>().fetchCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CollectionsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "我的收藏",
          style: TextStyle(color: Color(0xFF4A2B11), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A2B11), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: p.items.isEmpty
          ? const Center(
              child: Text("暂无收藏记录", style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: p.items.length,
              itemBuilder: (context, index) => CollectionItemTile(item: p.items[index]),
            ),
    );
  }
}
