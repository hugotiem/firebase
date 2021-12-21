import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/models/services/storage_service.dart';
import 'package:pts/models/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:path/path.dart';

part 'user_state.dart';

class UserCubit extends AppBaseCubit<UserState> {
  UserCubit() : super(UserState.initial());

  final AuthService service = AuthService();
  final FireStoreServices firestore = FireStoreServices("user");

  Future<void> init() async {
    await service.getToken().then((value) {
      print(value);
      if (value != null) emit(UserState.tokenLoaded(value));
    });
    service.instance.authStateChanges().listen((user) async {
      print("Current user : " + user.toString());
      if (user != null) {
        await this.loadData(user: user);
      } else {
        await service.setToken(null);
        emit(UserState.tokenLoaded(null));
      }
    });
  }

  Future<void> loadData({auth.User? user}) async {
    var token = user?.uid ?? await service.getToken();
    if (token != null) {
      firestore.getDataById(token).then((value) {
        emit(
            UserState.dataLoaded(user: User.fromSnapshot(value), token: token));
      }).catchError(onHandleError);
    } else {
      emit(UserState.dataLoaded(user: null, token: null));
    }
  }

  Future<void> updateUserInfo({String? name, String? surname}) async {
    emit(state.setRequestInProgress() as UserState);
    var id = await service.getToken();
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      // "surname": surname,
    };
    await firestore.setWithId(id, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> addId(File? file, String ref) async {
    if (file == null) return;
    final filename = basename(file.path);
    final destination = '$ref/$filename';
    emit(state.setRequestInProgress() as UserState);
    UploadTask? task = StorageService(destination).uploadFile(file);
    // ignore: unnecessary_null_comparison
    if (task == null) return;
    task.then((value) async {
      var id = await service.getToken();
      var url = await value.ref.getDownloadURL();
      Map<String, dynamic> data = <String, dynamic>{
        "$ref": url,
      };
      await firestore.setWithId(id, data: data);
      emit(UserState.dataLoaded(user: state.user, token: state.token));
    });
  }
}
