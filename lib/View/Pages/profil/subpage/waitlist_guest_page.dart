import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pts/components/ProfilPhoto.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/pts_box.dart';
import 'package:pts/components/title_appbar.dart';

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
          title: TitleAppBar(
            title: "Invités en attentes",
          )
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
        .collection('parties')
        .where('uid', isEqualTo: "AuthService.currentUser.uid") // NEED TO BE CHANGED
        .snapshots();
  }
}

Widget buildValidationCard(BuildContext context, DocumentSnapshot party) { 
  String partyName = party['name'];
  List nameList = party['wait list'];
  final _db = FirebaseFirestore.instance.collection('parties').doc(party.id);

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
                    doc['name'],
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
                onPressed: () async {
                  List list1 = [];
                    list1.add({
                      'name': doc['name'],
                      'uid': doc['uid']
                    });
                  
                  await _db
                      .update({
                        'validate guest list': FieldValue.arrayUnion(list1)
                      });
                  
                  await _db
                      .update({
                        'wait list': FieldValue.arrayRemove(list1)
                      });
                }, 
                icon: Icon( 
                  Icons.check_outlined,
                  color: Colors.green,
                )
              ),
              IconButton( 
                onPressed: () async {
                  List list1 = [];
                    list1.add({
                      'name': doc['name'],
                      'uid': doc['uid']
                    });

                  await _db
                      .update({
                        'wait list': FieldValue.arrayRemove(list1)
                      });
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
                  "Vous n'avez pas reçu de demande",
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