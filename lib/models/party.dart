import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:math' as math;

import 'package:pts/models/address.dart';

enum SmokeState { outside, inside, notAllowed }

enum AnimalState { allowed, notAllowed }

// ignore: must_be_immutable
class Party extends Equatable {
  String? id;
  String? name;
  String? theme;
  int? number;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  double? price;
  String? desc;
  Address? address;
  // String? address;
  // String? city;
  // String? postalCode;
  SmokeState? smoke;
  AnimalState? animals;
  var ownerId;
  List<dynamic>? validatedList;
  Map<String, dynamic>? validatedListInfo;
  int? distance;
  List<double?>? coordinates;
  List<double>? approximativeCoordinates;
  List? waitList;
  Map<String, dynamic>? waitListInfo;
  bool? isActive;
  String? userLink;
  List<dynamic>? commentIdList;
  Map<String, dynamic>? comment;

  Party(
      {this.id,
      this.name,
      this.theme,
      this.number,
      this.date,
      this.startTime,
      this.endTime,
      this.price,
      this.desc,
      this.address,
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
      this.distance,
      this.userLink});

  static String getTitleByState(SmokeState? state) {
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

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      "id": id,
      "name": name,
      "theme": theme,
      "number": number,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "price": price,
      "desc": desc,
      if (address?.streetNumber == null) "streetnumber": address?.streetNumber,
      "address": address?.streetName,
      "postalCode": address?.postalCode,
      "city": address?.city,
      "smoke": smoke?.index,
      "animals": animals?.index,
      "ownerId": ownerId,
      "validatedList": validatedList,
      "validatedListInfo": validatedListInfo,
      "coordinates": coordinates,
      "approximativeCoordinates": approximativeCoordinates,
      "waitList": waitList,
      "waitListInfo": waitListInfo,
      "isActive": isActive,
      "comment": comment,
      "commentIdList": commentIdList,
    };
    return json;
  }

  factory Party.fromJson(Map<String, dynamic>? json) {
    var id = json?["id"];
    var name = json?['name'];
    var theme = json?['theme'];
    var number = json?['number'];
    var date = json?['date'].toDate();
    var startTime = json?['startTime'].toDate();
    var endTime = json?['endTime'].toDate();
    double? price = json?['price'];
    var desc = json?['desc'];
    var address = Address.fromDB(json);
    var smoke = SmokeState.values[json?['smoke']];
    var animals = AnimalState.values[json?['animals']];
    var ownerId = json?['ownerId'];
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
        id: id,
        name: name,
        theme: theme,
        number: number,
        date: date,
        startTime: startTime,
        endTime: endTime,
        price: price,
        desc: desc,
        address: address,
        smoke: smoke,
        animals: animals,
        ownerId: ownerId,
        validatedList: validatedList,
        validatedListInfo: validatedListInfo,
        coordinates: coordinates,
        approximativeCoordinates: approximativeCoordinates,
        waitList: waitList,
        waitListInfo: waitListInfo,
        isActive: isActive,
        comment: comment,
        commentIdList: commentIdList);
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

  Party copyWith(
          {String? id,
          String? name,
          String? theme,
          int? number,
          DateTime? date,
          DateTime? startTime,
          DateTime? endTime,
          double? price,
          String? desc,
          Address? address,
          SmokeState? smoke,
          AnimalState? animals,
          var ownerId,
          List<dynamic>? validatedList,
          Map<String, dynamic>? validatedListInfo,
          int? distance,
          List<double?>? coordinates,
          List<double>? approximativeCoordinates,
          List? waitList,
          Map<String, dynamic>? waitListInfo,
          bool? isActive,
          String? userLink,
          List<dynamic>? commentIdList,
          Map<String, dynamic>? comment}) =>
      Party(
        id: id ?? this.id,
        name: name ?? this.name,
        theme: theme ?? this.theme,
        number: number ?? this.number,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        price: price ?? this.price,
        desc: desc ?? this.desc,
        address: address ?? this.address,
        smoke: smoke ?? this.smoke,
        animals: animals ?? this.animals,
        ownerId: ownerId ?? this.ownerId,
        validatedList: validatedList ?? this.validatedList,
        validatedListInfo: validatedListInfo ?? this.validatedListInfo,
        coordinates: coordinates ?? this.coordinates,
        approximativeCoordinates:
            approximativeCoordinates ?? this.approximativeCoordinates,
        waitList: waitList ?? this.waitList,
        waitListInfo: waitListInfo ?? this.waitListInfo,
        isActive: isActive ?? this.isActive,
        comment: comment ?? this.comment,
        commentIdList: commentIdList ?? this.commentIdList,
      );

  @override
  List<Object?> get props => [
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
        commentIdList
      ];
}
