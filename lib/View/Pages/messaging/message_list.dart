import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/constant.dart';
import 'package:pts/view/pages/messaging/subpage/chatpage.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar(title: "Messagerie"),
        )
      ),
      body: ListMessage(),
    );
  }
}

class ListMessage extends StatefulWidget {
  const ListMessage({ Key key }) : super(key: key);

  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _docs;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmessageStreamSnapshot(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
        _docs = snapshot.data.docs;
        return Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(  
            children: _docs.map((document) {
              return InkWell(
                onTap: () => openChat(  
                  document.id, document['name'], document['surname']),
                child: UserLineDesign(
                  document.id, document['name'], document['surname']),
                );
            }).toList(),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> getmessageStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('user')
    .snapshots();
  }

  void openChat(String userID, String name, String surname) {
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ChatPage(userID, name, surname))
    );
  }
}

class UserLineDesign extends StatelessWidget {
  final String _userID;
  final String _name;
  final String _surname;

  const UserLineDesign(this._userID, this._name, this._surname, { Key key }) 
   : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 10, bottom: 10),
      child: Row(  
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(  
              image: DecorationImage(
                image: AssetImage(  
                  "assets/roundBlankProfilPicture.png"
                )
              )
            ),
          ),
          const SizedBox(width: 20),
          Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$_name $_surname",
                style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
              Text(_userID, style: TextStyle(fontSize: 17))
            ],
          )
        ],
      ),
    );
  }
}