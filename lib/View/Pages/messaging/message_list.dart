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
  dynamic _docs;
  String currentUserId = AuthService().currentUser.uid;
  String currentUserName = AuthService().currentUser.displayName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmessageStreamSnapshot(context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
        _docs = snapshot.data;
        if (_docs.exists == false) return EmptyList();
        List listUser = snapshot.data['userid'];
        return Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(  
            children: listUser.map((doc) {
              return InkWell(
                onTap: () => openChat(doc['uid'], doc['name']),
                child: UserLineDesign(userID: doc['uid'], userName: doc['name'])
              );
            }).toList()
          )
        );
      },
    );
  }

  Stream<DocumentSnapshot> getmessageStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('chat')
        .doc(currentUserId)
        .snapshots();
  }

  void openChat(String userID, String userName) {
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ChatPage(userID, otherUserName: userName,))
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
      padding: const EdgeInsets.only(left: 24, top: 15, right: 24, bottom: 10),
      child: Row(  
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(  
              image: DecorationImage(
                image: AssetImage(  
                  "assets/roundBlankProfilPicture.png"
                )
              )
            ),
          ),
          const SizedBox(width: 16),
          Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              this.userName != null
              ? Container(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  this.userName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              )
              : Text(''),
              GetLastMessage(this.userID)
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

class GetLastMessage extends StatelessWidget {
  final String otherUserID;
  const GetLastMessage(this.otherUserID, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference chatService = FirebaseFirestore.instance.collection('chat');
    String currentUserID = AuthService().currentUser.uid;
    List<dynamic> _docs;
    return FutureBuilder<QuerySnapshot>(
      future: chatService
          .doc(currentUserID)
          .collection(otherUserID)
          .orderBy('date')
          .limitToLast(1)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('');
        _docs = snapshot.data.docs;
        return Row(  
          children: _docs.map((doc) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  doc['text'], 
                  overflow: TextOverflow.ellipsis,
                ),
              )
            );
          }).toList()
        );
      },
    );
  }
}