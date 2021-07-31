import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/profil/components/title_text_profil.dart';

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) { 
  String partyName = party['Name'];
  List nameList = party['wait list'];

  Stream<QuerySnapshot> getNameWaitList(BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('party')
        .where('UID', isEqualTo: AuthService.currentUser.uid)
        .snapshots();
  }

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
              nameList.toString() != '[]'
              ? StreamBuilder(
                stream: getNameWaitList(context),
                builder: (context, snapshot) {
                  return ListView.builder(
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
                                    nameList.toString(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    );
                }
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


