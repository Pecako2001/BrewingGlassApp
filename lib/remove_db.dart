import 'package:flutter/material.dart';
import 'functions/database_helper.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Delete Database Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteDatabaseFile();
            },
            child: Text('Delete Database'),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
