import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/functions/theme_provider.dart';
import 'pages/first_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/Inventorypage.dart';
import 'pages/Favorites_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: FirstPage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
        '/settingspage': (context) => SettingsPage(),
        '/inventorypage': (context) => InventoryPage(),
        '/favoritespage': (context) => FavoritesPage(),
      },
    );
  }
}
