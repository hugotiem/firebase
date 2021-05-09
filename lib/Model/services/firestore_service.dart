import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection;

  FireStoreServices(this.collection);

  FirebaseFirestore get firestore => _firestore;

  Future add({Map<String, dynamic> data}) async {
    await this._firestore.collection(collection).add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return this._firestore.collection(collection).snapshots();
  }
}
