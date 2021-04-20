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
                    color: SECONDARY_COLOR,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: 200,
                decoration: BoxDecoration(  
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9, top: 15, left: 10),
                        child: Row(  
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('Première page :')
                              ),
                            Container(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.edit)
                                  ),
                          ]
                        ),
                      )
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('le nom : ${Soiree.nom}')
                            ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('le thème : ${Soiree.theme}')
                            ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('le nombre : ${Soiree.nombre}')
                            ),
                        ],
                      )
                    )
                  ]
                )
              ),
            ),
            Text('le nom : ${Soiree.nom}, le thème : ${Soiree.theme}, le nombre : ${Soiree.nombre}',
            style: TextStyle(  
              fontSize: 20,
              color: SECONDARY_COLOR,
            ),
            ),
            Text('La date: ${Soiree.date.day}/${Soiree.date.month}/${Soiree.date.year} , L\'heure: ${Soiree.heure.format(context)} ',
            style: TextStyle(  
              fontSize: 20,
              color: SECONDARY_COLOR,
            ),
            ),
            Text('L\'adresse: ${Soiree.adresse}, la ville: ${Soiree.ville}, le code postal: ${Soiree.codepostal} ',
            style: TextStyle(  
              fontSize: 20,
              color: SECONDARY_COLOR,
              ),
            ),
            Text('prix : ${Soiree.paiement == true ? Soiree.prix : Soiree.gratuit} ',
            style: TextStyle(  
              fontSize: 20,
              color: SECONDARY_COLOR,
              ),
            ),
          ]
        )
      ),
    ); 
  }
}