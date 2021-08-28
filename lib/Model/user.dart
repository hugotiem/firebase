import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String surname;
  String gender;
  int age;

  User({this.id});

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var id = snapshot.id;

    return User(id: id);
  }
}
