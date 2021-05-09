import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future add({String collection, Map<String, dynamic> data}) async {
    await this._firestore.collection(collection).add(data);
  }

  //Future<> etData()
}
