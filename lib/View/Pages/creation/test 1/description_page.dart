import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

class DescriptionPage extends StatefulWidget {
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  String _description;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(  
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 30, 
                    bottom: 40,
                    left: 20
                    ),
                  child: Text(
                    "Un mot à ajouter pour décrire votre soirée ?",
                    style: TextStyle(  
                      wordSpacing: 1.5,
                      fontSize: 25,
                      color: SECONDARY_COLOR,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(  
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextFormField(  
                      onChanged: (value) {
                        _description = value;
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: Ambiance boîte de nuit !!', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                height: MediaQuery.of(context).size.height * 0.45,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                    primary: SECONDARY_COLOR,
                    elevation: 0,
                    shape: StadiumBorder()
                  ),
                  child: Text(
                    "Publier la soirée",
                    style: TextStyle(  
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
                    Soiree.setDataDescriptionPage(
                      _description
                    );

                    await db.collection("Party").add(
                      {
                        'Name' : Soiree.nom,
                        'Theme': Soiree.theme,
                        'Date': Soiree.date,
                        'Hour': Soiree.heure.format(context),
                        'Number': Soiree.nombre,
                        'Price': Soiree.prix,
                        'Description': Soiree.description
                      }
                    );
                  },
                ),
              )
            ]
          )
        ),
      );
  }
}