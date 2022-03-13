import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String ref;

  StorageService(this.ref);

  UploadTask uploadFile(File file) {
    return storage.ref(ref).putFile(file);
  }
}
