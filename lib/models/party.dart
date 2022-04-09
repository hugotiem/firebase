import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

enum SmokeState { outside, inside, notAllowed }
enum AnimalState { allowed, notAllowed }

class Party {
  String id;
  String name;
  String? theme;
  int? number;
  DateTime date;
  DateTime? startTime;
  DateTime? endTime;
  double? price;
  String? desc;
  String? address;
  String? city;
  String? postalCode;
  SmokeState? smoke;
  AnimalState? animals;
  var ownerId;
  List<dynamic>? validatedList;
  final Map<String, dynamic> validatedListInfo;
  int? distance;
  List<double> coordinates;
  List<double> approximativeCoordinates;
  List? waitList;
  final Map<String, dynamic> waitListInfo;
  bool? isActive;
  String? userLink;
  List<dynamic>? commentIdList;
  Map<String, dynamic>? comment;

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
      this.ownerId,
      this.validatedList,
      this.validatedListInfo,
      this.coordinates,
      this.approximativeCoordinates,
      this.waitList,
      this.waitListInfo,
      this.isActive,
      this.comment,
      this.commentIdList,
      {this.distance,
      this.userLink});

  static String getTitleByState(SmokeState state) {
    switch (state) {
      case SmokeState.outside:
        return "Oui, à l'exterieur";
      case SmokeState.inside:
        return "Oui, à l'interieur";
      default:
        return "Non";
    }
  }

  /// generate number between -0.001 and 0.001
  static double random() {
    double rand = ((math.Random().nextDouble() * 2) - 1) * 0.001;
    return rand;
  }

  factory Party.fromJson(Map<String, dynamic>? json) {
    var id = json?["id"];
    var name = json?['name'];
    var theme = json?['theme'];
    var number = json?['number'];
    print("date: ${json?['date']}");
    var date = json?['date'].toDate();
    var startTime = json?['startTime'].toDate();
    var endTime = json?['endTime'].toDate();
    double? price = json?['price'];
    var desc = json?['desc'];
    var address = json?['address'];
    var city = json?['city'];
    var postalCode = json?['postal code'];
    var smoke = SmokeState.values[json?['smoke']];
    var animals = AnimalState.values[json?['animals']];
    var ownerId = json?['party owner'];
    var validatedList = json?['validatedList'];
    var validatedListInfo =
        (json?['validatedListInfo'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
    var coordinates =
        ((json?['coordinates'] ?? []) as List<dynamic>).cast<double>();
    var approximativeCoordinates =
        coordinates.map((e) => e + random()).toList();
    var waitList = json?["waitList"];
    var waitListInfo =
        (json?["waitListInfo"] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
    var isActive = json?['isActive'];
    var comment = json?['comment'];
    var commentIdList = json?['commentIdList'];

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
        ownerId,
        validatedList,
        validatedListInfo,
        coordinates,
        approximativeCoordinates,
        waitList,
        waitListInfo,
        isActive,
        comment,
        commentIdList);
  }

  factory Party.fromSnapShots(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshots) {
    var id = snapshots.id;
    var data = snapshots.data();
    data["id"] = id;
    return Party.fromJson(data);
  }

  factory Party.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshots) {
    var id = snapshots.id;
    var data = snapshots.data();
    data?["id"] = id;
    return Party.fromJson(data);
  }
}
