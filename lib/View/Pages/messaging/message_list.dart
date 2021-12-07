import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/constant.dart';
import 'package:pts/model/services/auth_service.dart';
import 'package:pts/view/pages/messaging/subpage/chatpage.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar(title: "Messages"),
          backgroundColor: PRIMARY_COLOR,
        ),
      ),
      body: ListMessage(),
    );
  }
}

class ListMessage extends StatefulWidget {
  const ListMessage({Key? key}) : super(key: key);

  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic _docs;
  String currentUserId = AuthService().currentUser!.uid;
  String? currentUserName = AuthService().currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmessageStreamSnapshot(context),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return const Center(
            child: CircularProgressIndicator(),
          );
        _docs = snapshot.data;
        if (_docs.exists == false) return EmptyList();
        List listUser = snapshot.data!['userid'];
        return Container(
          margin: const EdgeInsets.only(bottom: 40, top: 10),
          child: Column(
            children: listUser.map(
              (doc) {
                return InkWell(
                  onTap: () => openChat(doc['uid'], doc['name']),
                  child:
                      UserLineDesign(userID: doc['uid'], userName: doc['name']),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  Stream<DocumentSnapshot> getmessageStreamSnapshot(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('chat')
        .doc(currentUserId)
        .snapshots();
  }

  void openChat(String? userID, String? userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userID!,
          otherUserName: userName,
        ),
      ),
    );
  }
}

class UserLineDesign extends StatelessWidget {
  final String? userID, userName;

  const UserLineDesign({this.userID, this.userName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/roundBlankProfilPicture.png"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.userName != null
                      ? Container(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            this.userName!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Text(''),
                  GetLastMessage(this.userID)
                ],
              ),
            ),
          ),
          GetTimeLastMessage(this.userID)
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, right: 18, left: 18),
      child: Container(
        child: Opacity(
          opacity: 0.85,
          child: Text(
            "Pas de message pour l'instant. Rejoingnez ou créez une soirée pour contacter quelqu'un.",
            style: TextStyle(color: SECONDARY_COLOR),
          ),
        ),
      ),
    );
  }
}

class GetLastMessage extends StatelessWidget {
  final String? otherUserID;
  const GetLastMessage(this.otherUserID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference chatService =
        FirebaseFirestore.instance.collection('chat');
    String currentUserID = AuthService().currentUser!.uid;
    List<dynamic> _docs;

    return FutureBuilder<QuerySnapshot>(
      future: chatService
          .doc(currentUserID)
          .collection(otherUserID!)
          .orderBy('date')
          .limitToLast(1)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('');
        _docs = snapshot.data!.docs;
        return Row(
          children: _docs.map((doc) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Opacity(
                  opacity: 0.64,
                  child: Text(
                    doc['text'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}

class GetTimeLastMessage extends StatelessWidget {
  final String? otherUserID;
  const GetTimeLastMessage(this.otherUserID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference chatService =
        FirebaseFirestore.instance.collection('chat');
    String currentUserID = AuthService().currentUser!.uid;
    List<dynamic> _docs;
    Duration dif;
    DateTime parsedDate;
    dynamic time, min, h, temps;
    double j;

    return FutureBuilder<QuerySnapshot>(
      future: chatService
          .doc(currentUserID)
          .collection(otherUserID!)
          .orderBy('date')
          .limitToLast(1)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('');
        _docs = snapshot.data!.docs;
        return Row(
          children: _docs.map((doc) {
            time = doc['date'].toString().split(" - ").join(" ");
            parsedDate = DateTime.parse(time);

            dif = DateTime.now().difference(parsedDate);

            min = int.parse(dif.toString().split(":")[1]);
            h = int.parse(dif.toString().split(':')[0]);
            j = h / 24;

            if (h > 24) {
              temps = "${j.round()} j";
            } else if (h >= 01) {
              temps = "$h h";
            } else if (min < 60) {
              temps = "$min min";
            }

            return Container(
              child: Opacity(
                opacity: 0.64,
                child: Text(
                  "$temps",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
