import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

class LastPage extends StatefulWidget {
  @override
  _LastPageState createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(  
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Récapitulatif :',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text('le nom : ${Soiree.nom}, le thème : ${Soiree.theme}, le nombre : ${Soiree.nombre}',
            style: TextStyle(  
              fontSize: 20,
              color: Colors.white,
            ),
            ),
          ]
        )
      ),
    ); 
  }
}