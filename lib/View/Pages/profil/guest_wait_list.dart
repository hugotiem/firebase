import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/soiree.dart';

import 'components/build_validation_card.dart';

class GuestWaitList extends StatelessWidget {
  const GuestWaitList({ 
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(  
          title: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text( 
              "Invités en attentes",
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
          stream: getGuestWaitList(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) => 
                buildValidationCard(context, snapshot.data.docs[index]),
            );
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getGuestWaitList(BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('party')
        .where('UID', isEqualTo: AuthService.currentUser.uid)
        .snapshots();
        // .map(_guestWaitList);
  }

  // https://stackoverflow.com/questions/62978458/firebase-cloud-firestore-get-array-of-maps-in-flutter

  // List<Soiree> _guestWaitList(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     List<WaitList> waitlist = [];
  //     List<dynamic> waitListMap = doc['wait list'];
  //     waitListMap.forEach((element) {
  //       waitlist.add(new WaitList(
  //         name: element['Name'],
  //       ));
  //     });
  //     return Soiree( 
  //       name: doc['Name'],
  //       waitlist: waitlist
  //     );
  //   }).toList();
  // }
 }