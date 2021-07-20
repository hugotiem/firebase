import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/View/Pages/search/search_party_card/search_party_card.dart';

import '../../../../../Constant.dart';

class ThemeBox extends StatelessWidget {
  final List<Color> colors;
  final String text;
  const ThemeBox({
    @required this.text,
    @required this.colors,
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
          padding: const EdgeInsets.only(left: 40, bottom: 20),
          child: Container(
            height: 145,
            width: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: this.colors
              )
            ),
            child: Center(
              child: Text(
                this.text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white
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
    .where('Theme', isEqualTo: this.text)
    .snapshots();
  }
}