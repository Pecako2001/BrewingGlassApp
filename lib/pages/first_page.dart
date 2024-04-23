import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:myapp/pages/Favorites_page.dart";
import "package:myapp/pages/home_page.dart";
import "package:myapp/pages/settings_page.dart";

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  final List _pages = [
    HomePage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("First page")),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items:  [
          // home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          
          // profile
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites'
          ),

          //setings
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]
        ),
      );
  }
}