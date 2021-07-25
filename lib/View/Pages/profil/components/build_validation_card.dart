import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/View/Pages/profil/components/title_text_profil.dart';


Widget buildValidationCard(BuildContext context, DocumentSnapshot party) {  
  return Stack(
    children: [
      Center(
        child: PTSBox(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextProfil(
                text: party['Name']
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Row(  
                    children: [
                      ProfilPhoto(),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            child: Text(
                              party['wait list'][index]['Name'],
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
              )
            ],
          ),
        ),
      )
    ]
  );
}


