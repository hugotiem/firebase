import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

// Dans cette troisième page du formualaire on retrouve : 
// l'adresse
// la ville
// le code postal

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      backgroundColor: BLUE_BACKGROUND,
      body: Column(
        children: <Widget>[

        ]
      ),
    );
  }
}