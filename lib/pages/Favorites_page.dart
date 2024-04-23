import 'package:flutter/material.dart';
import 'package:myapp/pages/add_item.dart';
import 'package:myapp/pages/item_repos.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> displayedItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedItems = ItemRepository().getItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      displayedItems = ItemRepository().getItems().where((item) =>
        item['glass'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        item['brewery'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedItems.length,
        itemBuilder: (context, index) {
          var item = displayedItems[index];
          return ListTile(
            title: Text(item['brewery'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${item['glass']} - Amount: ${item['amount']}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddItemScreen()),
        ).then((_) => setState(() {
          displayedItems = ItemRepository().getItems();
        })),
        child: const Icon(Icons.add),
      ),
    );
  }
}
