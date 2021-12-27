import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class Party {
  String id;
  String? name;
  String? theme;
  String? number;
  DateTime date;
  DateTime? startTime;
  DateTime? endTime;
  var price;
  String? desc;
  String? address;
  String? city;
  String? postalCode;
  String? smoke;
  String? animals;
  var owner;
  var uid;
  List<dynamic>? validateGuestList;
  int? distance;
  List<double> coordinates;
  List<double> approximativeCoordinates;

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
      this.uid,
      this.validateGuestList,
      this.coordinates,
      this.approximativeCoordinates,
      {this.distance});

  static double random() {
    // generate number between -0.001 and 0.001
    double rand = ((math.Random().nextDouble() * 2) - 1) * 0.001;
    return rand;
  }

  factory Party.fromSnapShots(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshots) {
    var id = snapshots.id;
    var data = snapshots.data();
    var name = data['name'];
    var theme = data['theme'];
    var number = data['number'];
    var date = data['date'].toDate();
    var startTime = data['startTime'].toDate();
    var endTime = data['endTime'].toDate();
    var price = data['price'];
    var desc = data['description'];
    var address = data['address'];
    var city = data['city'];
    var postalCode = data['postal code'];
    var smoke = data['smoke'];
    var animals = data['animals'];
    var owner = data['owner'];
    var uid = data['uid'];
    var validateGuestList = data['validate guest list'];
    var coordinates =
        ((data['coordinates'] ?? []) as List<dynamic>).cast<double>();
    var approximativeCoordinates =
        coordinates.map((e) => e + random()).toList();
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
        uid,
        validateGuestList,
        coordinates,
        approximativeCoordinates);
  }
}
