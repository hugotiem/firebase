import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/constant.dart';
import 'package:pts/model/services/auth_service.dart';
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
          title: TitleAppBar(title: "Boîte de réception"),
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
  var currentUserId = AuthService().currentUser.uid;
  var currentUserName = AuthService().currentUser.displayName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmessageStreamSnapshot(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
        _docs = snapshot.data.docs;
        if (_docs.isEmpty) return EmptyList();
        return Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(  
            children: _docs.map((document) {
              return InkWell(
                onTap: () => openChat(  
                  document.id),
                child: UserLineDesign(
                  userID: document.id),
                );
            }).toList(),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> getmessageStreamSnapshot(BuildContext context) async* {
    Map map = {'uid': currentUserId, 'name':  currentUserName};
    yield* FirebaseFirestore.instance
        .collection('chat')
        .where('userid', arrayContains: map)
        .snapshots();
  }

  void openChat(String userID) {
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ChatPage(userID))
    );
  }
}

class UserLineDesign extends StatelessWidget {
  final String userID, userName;

  const UserLineDesign({this.userID, this.userName, Key key }) 
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
              this.userName != null
              ? Text(
                this.userName,
                style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold))
              : Text(''),
              Text(this.userID, style: TextStyle(fontSize: 17))
            ],
          )
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, right: 18, left: 18),
      child: Container(  
        child: Opacity(
          opacity: 0.85,
          child: Text(
            "Pas de message pour l'instant. Rejoingnez ou créez une soirée pour contacter quelqu'un.",
            style: TextStyle(  
              color: SECONDARY_COLOR
            ),
          ),
        ),
      ),
    );
  }
}