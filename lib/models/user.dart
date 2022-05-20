import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final AuthService authService = AuthService();
  final FireStoreServices fireStoreServices = FireStoreServices("user");

  String? id;
  String? name;
  String? surname;
  String? gender;
  var age;
  var birthday;
  bool? hasIdChecked;
  String? phone;
  String? email;
  bool? verified;
  bool? banned;
  String? photo;
  String? mangoPayId;
  String? desc;

  User({
    this.id,
    this.name,
    this.surname,
    this.age,
    this.birthday,
    this.gender,
    this.hasIdChecked,
    this.email,
    this.phone,
    this.verified,
    this.banned,
    this.photo,
    this.mangoPayId,
    this.desc,
  });

  Future<User?> get currentUser async {
    var token = await authService.getToken();
    var data = await fireStoreServices.getDataById(token);
    if (!data.exists) return null;
    return User.fromSnapshot(data);
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var id = snapshot.id;
    var data = snapshot.data();
    var name = data?['name'];
    var surname = data?['surname'];
    var birthday = data?['birthday']?.toDate() ?? DateTime(2017);
    var now = DateTime.now();
    var age = (now.difference(birthday).inDays / 365).floor();
    var gender = data?['gender'];
    var phone = data?['phone number'];
    var email = data?['email'];
    var hasIdChecked = data?['idFront'] != null;
    var verified = data?['verified'];
    var banned = data?['banned'];
    var photo = data?['photo'];
    var mangoPayId = data?["mangoPayId"];
    var desc = data?["desc"];

    return User(
      id: id,
      name: name,
      surname: surname,
      hasIdChecked: hasIdChecked,
      age: age,
      gender: gender,
      email: email,
      phone: phone,
      verified: verified,
      banned: banned,
      birthday: birthday,
      photo: photo,
      mangoPayId: mangoPayId,
      desc: desc,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
        hasIdChecked,
        age,
        gender,
        email,
        phone,
        verified,
        banned,
        birthday,
        photo,
        mangoPayId,
        desc,
      ];
}
