import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/search/search_party_card/search_party_card.dart';

class GetPartyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: new BackAppBar(
          title: Padding(  
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Mes soirées',
              style: TextStyle(  
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.bold
              ),
            )
          )
        ),
      ),
      body: Container(
        child: StreamBuilder(
            stream: getPartyStreamSnapshots(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPartyCard(context, snapshot.data.docs[index]),
              );
            }),
      ),
    );
  }

  Stream<QuerySnapshot> getPartyStreamSnapshots(BuildContext context) async* {
    //à ajouter les soirées que l'utilisateur a créé et à rejoind
    //pour l'instant c'est la liste de toute les soirées créées par l'utilisateur
    yield* FirebaseFirestore.instance
        .collection('party')
        .where('UID', isEqualTo: AuthService.currentUser.uid)
        .snapshots();
  }
}
