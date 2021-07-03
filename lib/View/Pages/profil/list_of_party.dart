import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/View/Pages/search/Components/build_party_card.dart';

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
}