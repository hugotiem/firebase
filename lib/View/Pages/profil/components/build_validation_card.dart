import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/profil_photo.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/View/Pages/profil/components/title_text_profil.dart';

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) { 
  String partyName = party['Name'];
  List nameList = party['wait list'];

  List list = nameList.map((doc){
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: ProfilPhoto(),
              ),
              Container( 
                height: 70,
                child: Center(
                  child: Text(
                    doc['Name'],
                    style: TextStyle(  
                      fontSize: 17
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row( 
            children: [
              IconButton(
                onPressed: () {}, 
                icon: Icon( 
                  Icons.check_outlined,
                  color: Colors.green,
                )
              ),
              IconButton( 
                onPressed: () {},
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }).toList();

  // https://stackoverflow.com/questions/60178478/how-to-convert-an-array-of-map-in-firestore-to-a-list-of-map-dart
  // https://stackoverflow.com/questions/62978458/firebase-cloud-firestore-get-array-of-maps-in-flutter

  return Stack(
    children: [
      Center(
        child: PTSBox(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              TitleTextProfil(
                text: partyName
              ),
              nameList.isNotEmpty
              ? Column(
                children: list,
              )
              : Center(
                child: Text(
                  "Vous n'avez pas encore reçu de demande"
                ),
              )
            ],
          ),
        ),
      )
    ]
  );
}