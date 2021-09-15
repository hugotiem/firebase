import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection;

  FireStoreServices(this.collection);

  FirebaseFirestore get firestore => _firestore;

  Future<void> add({Map<String, dynamic> data}) async {
    await this._firestore.collection(collection).add(data);
  }

  Future<void> addWithId(String id, {Map<String, dynamic> data}) async {
    await this._firestore.collection(collection).doc(id).set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return this._firestore.collection(collection).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    return this._firestore.collection(collection).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataById(String id) async {
    return this._firestore.collection(collection).doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWithWhereIsEqualTo(
      String key, String data) async {
    return this
        ._firestore
        .collection(collection)
        .where(key, isEqualTo: data)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWithWhereArrayContains(
      String key, String name, String uid) async {
    Map _map = {'name': name, 'uid': uid};
    return this
        ._firestore
        .collection(collection)
        .where(key, arrayContains: _map)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataByOrder() async {
    return this
        ._firestore
        .collection(collection)
        .orderBy("timeStamp", descending: true)
        .get();
  }
}
