import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';

class User {
  final AuthService authService = AuthService();
  final FireStoreServices fireStoreServices = FireStoreServices("user");

  String? id;
  String? name;
  String? surname;
  String? gender;
  var age;
  bool? hasIdChecked;
  String? phone;
  String? email;

  User(
      {this.id,
      this.name,
      this.surname,
      this.age,
      this.gender,
      this.hasIdChecked,
      this.email,
      this.phone});

  Future<User?> get currentUser async {
    var token = await authService.getToken();
    var data = await fireStoreServices.getDataById(token);
    if (!data.exists) return null;
    return User.fromSnapshot(data);
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var id = snapshot.id;
    var data = snapshot.data()!;
    var name = data['name'];
    var surname = data['surname'];
    var birthday = data['birthday']?.toDate() ?? DateTime(2017);
    var now = DateTime.now();
    var age = (now.difference(birthday).inDays / 365).floor();
    var gender = data['gender'];
    var phone = data['phone number'];
    var email = data['email'];
    var hasIdChecked = data['idFront'] != null;

    return User(
        id: id,
        name: name,
        surname: surname,
        hasIdChecked: hasIdChecked,
        age: age,
        gender: gender,
        email: email,
        phone: phone);
  }
}
