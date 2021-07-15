import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/View/Pages/search_party_card/build_party_card.dart';

import '../../../../../Constant.dart';

class CityBox extends StatelessWidget {
  final String text;
  const CityBox({
    @required this.text,
    Key key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 400),
      closedColor: Colors.transparent,
      openColor: PRIMARY_COLOR,
      closedElevation: 0,
      closedBuilder: (context, returnvalue) {
        return Padding(
          padding: const EdgeInsets.only(left: 32, top: 16),
            child: Container(
              height: 75,
              width: 150,
              decoration: BoxDecoration(
                color: SECONDARY_COLOR,
                borderRadius: BorderRadius.circular(15)
                ),
              child: Center(
                child: Text(
                  this.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: FOCUS_COLOR
                ),
              ),
            ),
          ),
        );
      },

      openBuilder: (context, returnvalue) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: new BackAppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  this.text,
                  style: TextStyle(  
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            child: StreamBuilder(
              stream: getPartyStreamSnapshot(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                    buildPartyCard(context, snapshot.data.docs[index])
                );
              }, 
            )
          ),
        );
      },
    );
  }
  Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('party')
    .where('city', isEqualTo: this.text)
    .snapshots();
  }
}
