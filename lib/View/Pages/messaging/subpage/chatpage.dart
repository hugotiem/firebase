import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/constant.dart';
import 'package:pts/model/Capitalize.dart';
import 'package:pts/model/services/auth_service.dart';

class ChatPage extends StatelessWidget {
  final otherUserID;
  final otherUserName;

  const ChatPage(String this.otherUserID,
  { this.otherUserName, Key key }) 
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: BackAppBar(
          title: Row(
            children: [
              Text(  
                otherUserName == null 
                ? ''
                : otherUserName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(  
                  color: SECONDARY_COLOR
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MessageField(otherUserID),
      body: Container(
        padding: EdgeInsets.all(10),
        color: PRIMARY_COLOR,
        child: ListMessage(otherUserID),
      )
    );
  }
}

class MessageField extends StatelessWidget {
  final textfield = TextEditingController();
  final String otherUserID;
  MessageField(this.otherUserID, { Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        child: Container(  
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.crop_original_outlined)
              ),
              Expanded(  
                child: Padding(
                  padding: const EdgeInsets.only(right: 16), //,top: 7, bottom: 7),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: SECONDARY_COLOR, width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: textfield,
                              decoration: InputDecoration(  
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: "écrivez un message".inCaps
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => sendMessage(),
                          icon: Icon(Icons.arrow_forward_outlined),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  void sendMessage() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var currentUserId = AuthService().currentUser.uid;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm:ss').format(now);
    try {
      firestore.collection("chat").doc(currentUserId).collection(otherUserID).add({
        'text': textfield.text,
        'userid': currentUserId,
        'date': formattedDate
      }).then((value) {
        firestore.collection("chat").doc(otherUserID).collection(currentUserId).add({
          'text': textfield.text,
          'userid': currentUserId,
          'date': formattedDate,
        }).then((value) {
          print('message envoyé');
          textfield.clear();
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

class ListMessage extends StatefulWidget {
  final String otherUserID;
  const ListMessage(this.otherUserID, { Key key }) : super(key: key);

  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  List<DocumentSnapshot> _docs;
  var currentUserId = AuthService().currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmessageStreamSnapshot(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        _docs = snapshot.data.docs;
        if (_docs.isEmpty) {
          return const Center(child: Text("Envoyer votre premier message"),);
        }
        return SingleChildScrollView(  
          child: Column(  
            children: _docs.map((document) {
              return document['userid'] == currentUserId 
              ? CurrentUserMessage(document['text'], document['date'])
              : OtherUserMessage(document['text'], document['date']);
            }).toList()
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> getmessageStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('chat')
    .doc(currentUserId)
    .collection(widget.otherUserID)
    .orderBy("date")
    .snapshots();
  }
}

class CurrentUserMessage extends StatelessWidget {
  final String textMessage;
  final String dateMessage;
  const CurrentUserMessage(this.textMessage, this.dateMessage, {Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            dateMessage.toString().substring(13, 18),
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: SECONDARY_COLOR,
            ),
            child: Center(
              child: Text(
                textMessage,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OtherUserMessage extends StatelessWidget {
  final String textMessage;
  final String dateMessage;
  const OtherUserMessage(this.textMessage, this.dateMessage, {Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                textMessage,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          Text(
            dateMessage.toString().substring(13, 18),
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}