import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  List names = ["Test1", "Test2", "test3"];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 200, 100),
        appBar: AppBar(
          title: Text("This is my Appbar"),
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
          elevation: 0,
          leading: Icon(Icons.menu),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.logout, color: Colors.black,))
          ],
          ),
        body: Center(
          child: Container(
            height: 300,
            width:300,
            color: Colors.yellow,
            child: Center(child: Text("Tap me")),
          ),
        )
      )
    );
  }
}