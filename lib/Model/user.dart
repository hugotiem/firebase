import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';

class User {
  final AuthService authService = AuthService();
  final FireStoreServices fireStoreServices = FireStoreServices("user");

  String id;
  String name;
  String surname;
  String gender;
  int age;

  User({this.id, this.name, this.surname});

  Future<User> get currentUser async {
    var token = await authService.getToken();
    var data = await fireStoreServices.getDataById(token);
    return User.fromSnapshot(data);
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var id = snapshot.id;
    var data = snapshot.data();
    var name = data['name'];
    var surname = data['surname'];

    return User(id: id, name: name, surname: surname);
  }
}
