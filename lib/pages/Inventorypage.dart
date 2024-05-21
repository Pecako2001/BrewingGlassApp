import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/functions/add_item.dart';
import 'package:provider/provider.dart';
import 'package:myapp/functions/theme_provider.dart';
import 'package:myapp/functions/database_helper.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> glasses = [];
  String _sortCriterion = 'name';

  @override
  void initState() {
    super.initState();
    _fetchGlasses();
  }

  Future<void> _fetchGlasses() async {
    final List<Map<String, dynamic>> fetchedGlasses = await DatabaseHelper.instance.getGlasses();
    setState(() {
      glasses = fetchedGlasses;
    });
  }

  void _addGlass(String name, String brewery, int amount, double rating) {
    _fetchGlasses(); // Refresh the list after adding a new glass
  }

  void _editGlass(int id, String name, String brewery, int amount, double rating) {
    final glass = {
      'id': id,
      'name': name,
      'brewery': brewery,
      'amount': amount,
      'rating': rating,
    };
    DatabaseHelper.instance.updateGlass(glass);
    _fetchGlasses(); // Refresh the list after editing a glass
  }

  void _deleteGlass(int id) async {
    await DatabaseHelper.instance.deleteGlass(id);
    _fetchGlasses(); // Refresh the list after deleting a glass
  }

  void _openAddGlassSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddItemScreen(
          addGlassCallback: _addGlass,
        );
      },
    );
  }

  void _openEditGlassSheet(Map<String, dynamic> glass) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddItemScreen(
          addGlassCallback: (name, brewery, amount, rating) {
            _editGlass(glass['id'], name, brewery, amount, rating);
          },
          existingGlass: glass,
        );
      },
    );
  }

  void _sortGlasses(String criterion) {
    setState(() {
      _sortCriterion = criterion;
      glasses.sort((a, b) => a[criterion].compareTo(b[criterion]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sorting section
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _sortGlasses('brewery');
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Brewery'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _sortGlasses('style');
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Style'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _sortGlasses('country');
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Country'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _sortGlasses(_sortCriterion);
                    },
                    child: Text('Sort'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Glasses List
            Expanded(
              child: ListView.builder(
                itemCount: glasses.length,
                itemBuilder: (context, index) {
                  final glass = glasses[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    child: ListTile(
                      leading: glass['image_path'] != null 
                          ? Image.file(
                              File(glass['image_path']),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.local_drink, size: 40, color: isDarkMode ? Colors.white : Colors.black),
                      title: Text(glass['name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(glass['brewery'], style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
                          Text('${glass['amount']} glasses', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < glass['rating'] ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              );
                            }),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () => _openEditGlassSheet(glass),
                      ),
                      onLongPress: () => _deleteGlass(glass['id']),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddGlassSheet,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
