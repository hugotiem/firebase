import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection;

  FireStoreServices(this.collection);

  FirebaseFirestore get firestore => _firestore;

  DocumentReference<Map<String, dynamic>> document(String id) =>
      _firestore.collection(collection).doc(id);

  Future<String?> add({Map<String, dynamic>? data}) async {
    if (data == null) return null;
    var query = await this._firestore.collection(collection).add(data);
    return query.id;
  }

  Future<void> setWithId(String? id,
      {required Map<String, dynamic> data, String? path}) async {
    if (path != null) {
      var field = path.split(".")[0];
      var value = path.split(".")[1];
      await this._firestore.collection(collection).doc(id).set({
        field: {value: data}
      }, SetOptions(merge: true));
    } else {
      await this
          ._firestore
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: true));
    }
  }

  Future<void> updateValue(String? id, Map<String, dynamic> data) async {
    await this._firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteValue(String id, String path) async {
    await this
        .firestore
        .collection(collection)
        .doc(id)
        .update({path: FieldValue.delete()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return this._firestore.collection(collection).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    return this._firestore.collection(collection).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getActiveData() async {
    return this
        ._firestore
        .collection(collection)
        .where("isActive", isEqualTo: true)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataById(String? id) async {
    return this._firestore.collection(collection).doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWithMultipleWhereIsEqualTo(
      Map<String, dynamic> conditions) async {
    Query<Map<String, dynamic>> query = this._firestore.collection(collection);
    for (var condition in conditions.keys) {
      var cond = conditions[condition];
      if (cond is List) {
        query = query.where(condition, whereIn: cond);
      } else if (condition == 'price') {
        query = query.where(condition, isLessThanOrEqualTo: cond);
      } else {
        query = query.where(condition, isEqualTo: cond);
      }
    }
    return query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWithWhereIsEqualTo(
      String key, String? data) async {
    return this
        ._firestore
        .collection(collection)
        .where(key, isEqualTo: data)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      getDataWithWhereIsEqualToAndIsActive(String key, String? data) async {
    return this
        ._firestore
        .collection(collection)
        .where(key, isEqualTo: data)
        .where("isActive", isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWithWhereMapContains(
      String field, String? uid) async {
    return this
        ._firestore
        .collection(collection)
        .where(field, arrayContains: uid)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataByOrder() async {
    return this
        ._firestore
        .collection(collection)
        .orderBy("timeStamp", descending: true)
        .get();
  }

  Stream<QuerySnapshot> getMessageStreamSnapshot(
      String currentUserID, String otherUserID) async* {
    yield* this
        ._firestore
        .collection(collection)
        .doc(currentUserID)
        .collection(otherUserID)
        .orderBy("date")
        .snapshots();
  }
}
