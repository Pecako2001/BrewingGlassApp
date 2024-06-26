import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/functions/theme_provider.dart';
import 'package:myapp/functions/database_helper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Dutch', 'French', 'German'];
  final Map<String, String> _languageFlags = {
    'English': 'assets/flags/united-kingdom.png',
    'Dutch': 'assets/flags/netherlands.png',
    'French': 'assets/flags/france.png',
    'German': 'assets/flags/germany.png',
  };
  int _totalGlasses = 0;
  int _uniqueGlasses = 0;

  @override
  void initState() {
    super.initState();
    _fetchGlassesData();
  }

  Future<void> _fetchGlassesData() async {
    final totalGlasses = await DatabaseHelper.instance.getTotalGlasses();
    final uniqueGlasses = await DatabaseHelper.instance.getUniqueGlasses();
    setState(() {
      _totalGlasses = totalGlasses;
      _uniqueGlasses = uniqueGlasses;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Profile Info Section
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/profile/profile_picture.png'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lorem Ipsum',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lid geworden op 27 sep. 2019',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('GLAZEN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          // Statistics Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('TOTAL', style: TextStyle(color: Colors.grey)),
                  Text('$_totalGlasses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  Text('UNIQUE', style: TextStyle(color: Colors.grey)),
                  Text('$_uniqueGlasses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Language Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Language:', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                    _changeLanguage(newValue);
                  });
                },
                items: _languages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Image.asset(
                          _languageFlags[value]!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Dark Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dark Mode:', style: TextStyle(fontSize: 18)),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          // Photos Section
          Text("FOTO'S", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Image.asset('assets/profile/sample_photo.jpg', width: 100, height: 100, fit: BoxFit.cover),
                SizedBox(width: 10),
                Image.asset('assets/profile/sample_photo.jpg', width: 100, height: 100, fit: BoxFit.cover),
                SizedBox(width: 10),
                Image.asset('assets/profile/sample_photo.jpg', width: 100, height: 100, fit: BoxFit.cover),
                SizedBox(width: 10),
                Image.asset('assets/profile/sample_photo.jpg', width: 100, height: 100, fit: BoxFit.cover),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Beer Statistics Section
          Text('RATINGS', style: TextStyle(fontSize: 18)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[800],
            child: Column(
              children: [
                Text('BEKIJK MEER', style: TextStyle(color: Colors.blue)),
                SizedBox(height: 10),
                Container(
                  height: 100,
                  color: Colors.blueGrey,
                ),
                SizedBox(height: 10),
                Text('3.59', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                Text('Schaal', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(String language) {
    // Implement the language change functionality here
    // This can involve updating the app's locale or other necessary steps
  }
}
