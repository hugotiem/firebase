import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/firstpage.dart';

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
      body:Container(
        child: Column(  
          children: [
            Container(
              child: Text(
                'Récapitulatif',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                  ),
                )
              ),
            // premiere page
            Center(
              child: PTSBox(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container( 
                        decoration: BoxDecoration(  
                          border: Border(  
                            bottom: BorderSide(  
                              color: Colors.grey
                            )
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(  
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container( 
                                child: Text(
                                  'Première page',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25, 
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 25,
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(  
                        decoration: BoxDecoration(  
                          border: Border(
                            bottom: BorderSide(  
                              color: Colors.grey.withOpacity(0.23)
                            )
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Opacity(
                            opacity: 0.75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container( 
                                  child: Text(
                                    'Nom: ${Soiree.nom}',
                                    style: TextStyle(  
                                      fontSize: 16,
                                    ),
                                  )
                                ),
                              Container(
                                child: Icon(Icons.create_outlined,
                                  size: 20,)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(  
                        decoration: BoxDecoration(  
                          border: Border(
                            bottom: BorderSide(  
                              color: Colors.grey.withOpacity(0.23)
                            )
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Opacity(
                            opacity: 0.75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container( 
                                  child: Text(
                                    'Thème: ${Soiree.theme}',
                                    style: TextStyle(  
                                      fontSize: 16
                                    ),
                                  )
                                ),
                                Container(
                                  child: Icon(Icons.party_mode_outlined,
                                  size: 20,)
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(  
                      child: Opacity(
                        opacity: 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container( 
                              child: Text(
                                'Nombre: ${Soiree.nombre}',
                                style: TextStyle(  
                                  fontSize: 16
                                ),
                              )
                            ),
                            Container(
                              child: Icon(Icons.person_add_alt_1_outlined,
                              size: 20,)
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            // deuxieme page
            PTSBox(
              child: Column(  
                children: [
                  Container(
                    child: Row(  
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text('Date et Heure')
                        ),
                      ]
                    )
                  )
                ]
              )
            )
          ]
        )
      ) 
    );
  }
}