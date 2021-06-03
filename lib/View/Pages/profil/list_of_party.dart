import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Constant.dart';

class GetPartyData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getPartyStreamSnapshots(context),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) =>
              buildPartyCard(context, snapshot.data.docs[index])
          );
        }
      ),
    );
  }

  Stream<QuerySnapshot> getPartyStreamSnapshots(BuildContext context) async* {
    //à ajouter les soirées que l'utilisateur a créé et à rejoind
    //pour l'instant c'est la liste de toute les soirées créées
    yield* FirebaseFirestore.instance
    .collection('party')
    .snapshots();
  }

  Widget buildPartyCard(BuildContext context, DocumentSnapshot party) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: PRIMARY_COLOR,
        child: Column(  
          children: [
            Text(party['Name'])
          ]
        ),
      ),
    );
  }
}