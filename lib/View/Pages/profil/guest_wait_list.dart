import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';

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
              "Invités",
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
  }
}