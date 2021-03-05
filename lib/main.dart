import 'package:flutter/material.dart';
import 'View/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = "Upload Flutter To GitHub";

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PTS",
      //theme: ,
      home: Home(),
    );
  }
}
