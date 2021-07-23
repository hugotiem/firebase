import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/profil/components/title_text_profil.dart';


Widget buildValidationCard(BuildContext context, DocumentSnapshot party) {  
  String name = party['Name'];

  Stream<QuerySnapshot> getNameList(BuildContext context) async* {
  yield* FirebaseFirestore.instance
      .collection('party')
      .where('UID', isEqualTo: AuthService.currentUser.uid)
      .where(party['wait list'][0]['party name'], isEqualTo: party['Name'])
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
            children: [
              TitleTextProfil(
                text: name
              ),
              TextButton(
                onPressed: () {
                  print(party['wait list'][0]['party name']);
                }, 
                child: Text(
                  'test'
                )
              ),
              StreamBuilder(
                stream: getNameList(context),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) =>
                      buildNameList(context, snapshot.data.docs[index])
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



Widget buildNameList(BuildContext context, DocumentSnapshot party) {
  return Row(  
      children: [
        Container(
          height: 50,
          child: Text(
            party['wait list'].toString(),
          ),
        )
      ],
    );
}

