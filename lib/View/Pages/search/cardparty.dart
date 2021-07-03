import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Components/build_party_card.dart';

class CardParty extends StatefulWidget {
  const CardParty({ Key key }) : super(key: key);

  @override
  _CardPartyState createState() => _CardPartyState();
}

class _CardPartyState extends State<CardParty> {
  // ignore: unused_field
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPartyStreamSnapshot(context),
      builder:  (context, snapshot) {
         if (!snapshot.hasData) return const Text('Loading...');
         return PageView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            controller: PageController(viewportFraction: 0.85),
            onPageChanged: (int index) =>
              setState(() => _index = index),
              itemBuilder: (BuildContext context, int index) => 
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: buildPartyCard(context, snapshot.data.docs[index]),
                )
              );
            }
          );
        }

  Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('party')
    .snapshots();
  }
}

