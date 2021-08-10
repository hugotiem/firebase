import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Constant.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/components/party_card/party_card.dart';

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
      body: Column(
        children: [
          Expanded(
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
            Expanded(
              child: StreamBuilder(
                stream: getStream(context),
                builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildPartyCard(context, snapshot.data.docs[index]),
                );
              }),
            ),
        ])
      );
  }

  Stream<QuerySnapshot> getPartyStreamSnapshots(BuildContext context) async* {
    final _db = FirebaseFirestore.instance.collection('party');
    
    yield* _db
        .where('UID', isEqualTo: AuthService.currentUser.uid)
        .snapshots();
  }


  Stream<QuerySnapshot> getStream(BuildContext context) async* {
    final _db = FirebaseFirestore.instance.collection('party');
    Map _uid = {
      'Name': AuthService.currentUser.displayName.split(' ')[0],
      'uid': AuthService.currentUser.uid
    };

    yield* _db
        .where('validate guest list', arrayContains: _uid)
        .snapshots();
  }
}
