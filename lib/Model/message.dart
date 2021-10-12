import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String date;
  String text;
  String userid;

  Message(this.date, this.text, this.userid);

  factory Message.fromSnapShots(QuerySnapshot<Object> snapshot) {
    var data = snapshot.docs;
    var date = data.map((e) {
      return e['date'];
    }).toString();
    var text = data.map((e) {
      return e["text"];
    }).toString();
    var uid = data.map((e) => e["userid"]).toString();
    return Message(date, text, uid);
  }
}