import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/const.dart';
import 'package:pts/models/Capitalize.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.Dart' as Path;
import 'package:pts/models/services/storage_service.dart';

class ChatPage extends StatelessWidget {
  final otherUserID;
  final otherUserName;

  const ChatPage(String this.otherUserID, {this.otherUserName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: BackAppBar(
              backgroundColor: PRIMARY_COLOR,
              elevation: 0.5,
              title: TitleAppBar(
                  otherUserName == null ? '' : otherUserName)),
        ),
        bottomNavigationBar: MessageField(otherUserID),
        body: Container(
          padding: EdgeInsets.all(10),
          color: PRIMARY_COLOR,
          child: ListMessage(otherUserID),
        ));
  }
}

class MessageField extends StatefulWidget {
  final String otherUserID;
  const MessageField(this.otherUserID, {Key? key}) : super(key: key);

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  TextEditingController textfield = TextEditingController();
  bool? selected;
  File? image;

  @override
  void initState() {
    setState(() {
      selected = false;
    });
    super.initState();
  }

  void sendMessage(String message) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var currentUserId = AuthService().currentUser!.uid;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm:ss').format(now);
    try {
      firestore
          .collection("chat")
          .doc(currentUserId)
          .collection(widget.otherUserID)
          .add({
        'text': message,
        'userid': currentUserId,
        'date': formattedDate
      }).then((value) {
        firestore
            .collection("chat")
            .doc(widget.otherUserID)
            .collection(currentUserId)
            .add({
          'text': message,
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

  void sendPhoto() async {
    String fileName = Path.basename(image!.path);
    String destination = 'Messagerie/$fileName';
    UploadTask task = StorageService(destination).uploadFile(image!);

    // if (task == null) return;
    task.then((element) async {
      var url = await element.ref.getDownloadURL();
      sendMessage(url);
    });

    Navigator.pop(context);
  }

  Future<void> photoDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Prendre une photo'),
            content: Text(
                'Prenez une nouvelle photo ou importez-en une depuis votre bibliothèque.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => pickImage(),
                  child: Text('GALERIE',
                      style: TextStyle(color: SECONDARY_COLOR))),
              TextButton(
                  onPressed: () => takePhoto(),
                  child: Text(
                    'APPAREIL',
                    style: TextStyle(color: SECONDARY_COLOR),
                  ))
            ],
          );
        });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      Navigator.pop(context);
      photoSelected();
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  Future takePhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      Navigator.pop(context);
      photoSelected();
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  Future photoSelected() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: BackAppBar(actions: [
                  TextButton(
                    onPressed: () => sendPhoto(),
                    child: Text(
                      'Envoyer',
                      style: TextStyle(color: SECONDARY_COLOR, fontSize: 16),
                    ),
                  ),
                ]),
              ),
            ),
            body: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Container(
                  child: Image.file(image!),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        color: PRIMARY_COLOR,
        child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                      onPressed: () => photoDialog(),
                      icon: Icon(Ionicons.image_outline,
                          color: SECONDARY_COLOR)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Opacity(
                      opacity: selected == false ? 0.4 : 0.9,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: SECONDARY_COLOR,
                                width: selected == false ? 1 : 1.6),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 5),
                                child: FocusScope(
                                  child: Focus(
                                    onFocusChange: (focus) {
                                      if (focus == true) {
                                        setState(() {
                                          selected = true;
                                        });
                                      } else if (focus == false) {
                                        setState(() {
                                          selected = false;
                                        });
                                      }
                                    },
                                    child: TextField(
                                      controller: textfield,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          hintText:
                                              "écrivez un message".inCaps),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => sendMessage(textfield.text),
                              icon: Opacity(
                                  opacity: selected == false ? 0.7 : 0.9,
                                  child: Icon(
                                    Ionicons.arrow_forward_outline,
                                    color: SECONDARY_COLOR,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class ListMessage extends StatefulWidget {
  final String otherUserID;
  const ListMessage(this.otherUserID, {Key? key}) : super(key: key);

  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  late List<DocumentSnapshot> _docs;
  var currentUserId = AuthService().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: StreamBuilder(
        stream: getmessageStreamSnapshot(context),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          _docs = snapshot.data!.docs;
          if (_docs.isEmpty) {
            return const Center(
              child: Text("Envoyer votre premier message"),
            );
          }
          return SingleChildScrollView(
            child: Column(
                children: _docs.map((document) {
              return document['userid'] == currentUserId
                  ? CurrentUserMessage(document['text'], document['date'])
                  : OtherUserMessage(document['text'], document['date']);
            }).toList()),
          );
        },
      ),
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
  final String? textMessage;
  final String? dateMessage;
  const CurrentUserMessage(this.textMessage, this.dateMessage, {Key? key})
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
            padding: detect(textMessage!) == false
                ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
                : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: SECONDARY_COLOR,
            ),
            child: Center(
              child: Container(
                  padding: detect(textMessage!) == false
                      ? EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 5)
                      : null,
                  width: textMessage!.length >= 50
                      ? MediaQuery.of(context).size.width * 0.6
                      : null,
                  child: message(textMessage!)),
            ),
          ),
        ],
      ),
    );
  }
}

class OtherUserMessage extends StatelessWidget {
  final String? textMessage;
  final String? dateMessage;
  const OtherUserMessage(this.textMessage, this.dateMessage, {Key? key})
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
            padding: detect(textMessage!) == false ? const EdgeInsets.fromLTRB(10, 0, 10, 0) : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Container(
                padding:
                    detect(textMessage!) == false ? EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 5) : null,
                width: textMessage!.length >= 50
                    ? MediaQuery.of(context).size.width * 0.6
                    : null,
                child: message(textMessage!, color: SECONDARY_COLOR)
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

bool detect(String str) {
  if (str.toString().contains('https://firebasestorage.googleapis.com/v0/b/pts-beta-yog.appspot.com/o/Messagerie%')) {
    return true;
  } else {
    return false;
  }
}

Widget message(String str, {Color? color}) {
  if (detect(str) == true) {
    return Image.network(
      str,
      fit: BoxFit.cover,
    );
  } else {
    return Text(
      str,
      style: TextStyle(color: color == null ? Colors.white : color, fontSize: 17),
    );
  }
}
