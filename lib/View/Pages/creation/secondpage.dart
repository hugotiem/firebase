import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar()
      ),
      body: SingleChildScrollView(
        child: Column(
          
        ),
      ),
    );
  }
}