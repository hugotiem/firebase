import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/components/ProfilPhoto.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/pts_box.dart';

import '../../../../Constant.dart';
import '../Profil_page.dart';

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
  }
}

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) { 
  String partyName = party['Name'];
  List nameList = party['wait list'];

  List list = nameList.map((doc) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: ProfilPhoto(),
              ),
              Container( 
                height: 70,
                child: Center(
                  child: Text(
                    doc['Name'],
                    style: TextStyle(  
                      fontSize: 17
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row( 
            children: [
              IconButton(
                onPressed: () {}, 
                icon: Icon( 
                  Icons.check_outlined,
                  color: Colors.green,
                )
              ),
              IconButton( 
                onPressed: () async {
                  List list1 = [];
                    list1.add({
                      'Name': doc['Name'],
                      'uid': doc['uid']
                    });

                  await FirebaseFirestore.instance
                      .collection('party')
                      .doc(party.id)
                      .update({
                        'wait list':
                          FieldValue.arrayRemove(
                            list1
                        )
                      } 
                    );
                },
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }).toList();

  return Stack(
    children: [
      Center(
        child: PTSBox(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              TitleTextProfil(
                text: partyName
              ),
              nameList.isNotEmpty
              ? Column(
                children: list,
              )
              : Center(
                child: Text(
                  "Vous n'avez pas encore reçu de demande",
                  style: TextStyle(
                    fontSize: 17
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]
  );
}