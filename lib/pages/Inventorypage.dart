import 'package:flutter/material.dart';
import 'package:myapp/pages/add_item.dart'; // Ensure this import is correct
import 'package:provider/provider.dart';
import 'package:myapp/functions/theme_provider.dart';
import 'package:myapp/pages/item_repos.dart'; // Ensure this is added to your pubspec.yaml

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> glasses = [];

  void _addGlass(String name, String brewery, int amount, double rating) {
    setState(() {
      glasses.add({
        'name': name,
        'brewery': brewery,
        'amount': amount,
        'rating': rating,
      });
    });
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

  @override
  Widget build(BuildContext context) {
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
                      // Sort by brewery
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Brewery'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Sort by style
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Style'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Sort by country
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Country'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Sort
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
                    color: Colors.grey[850],
                    child: ListTile(
                      leading: Icon(Icons.local_drink, size: 40, color: Colors.white),
                      title: Text(glass['name'], style: TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(glass['brewery'], style: TextStyle(color: Colors.white70)),
                          Text('${glass['amount']} in stock', style: TextStyle(color: Colors.white70)),
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
                      trailing: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
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
