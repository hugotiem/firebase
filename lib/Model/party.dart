import 'package:cloud_firestore/cloud_firestore.dart';

class Party {
  String id;
  String name;
  String theme;
  String number;
  var date;
  DateTime startTime;
  DateTime endTime;
  var price;
  String desc;
  String address;
  String city;
  String postalCode;
  String smoke;
  String animals;
  String owner;
  List<String> validateGuestList;

  Party(
    this.id,
    this.name,
    this.theme,
    this.number,
    this.date,
    this.startTime,
    this.endTime,
    this.price,
    this.desc,
    this.address,
    this.city,
    this.postalCode,
    this.smoke,
    this.animals,
    this.owner,
    this.validateGuestList,
  );

  factory Party.fromSnapShots(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshots) {
    var id = snapshots.id;
    var name = snapshots['name'];
    var theme = snapshots['theme'];
    var number = snapshots['number'];
    var date = snapshots['date'].toDate();
    var startTime = snapshots['startTime'].toDate();
    var endTime = snapshots['endTime'].toDate();
    var price = snapshots['price'];
    var desc = snapshots['desc'];
    var address = snapshots['address'];
    var city = snapshots['city'];
    var postalCode = snapshots['postal code'];
    var smoke = snapshots['smoke'];
    var animals = snapshots['animals'];
    var owner = snapshots['owner'];
    var validateGuestList = snapshots['validate guest list'];
    return Party(
      id,
      name,
      theme,
      number,
      date,
      startTime,
      endTime,
      price,
      desc,
      address,
      city,
      postalCode,
      smoke,
      animals,
      owner,
      validateGuestList,
    );
  }
}
