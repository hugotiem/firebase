import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/services/storage_service.dart';
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
      emit(UserState.tokenLoaded(value));
    });
    service.instance.authStateChanges().listen((user) async {
      if (user != null) {
        emit(state.setRequestInProgress() as UserState);
        await this.loadData(user: user);
      } else {
        await service.setToken(null);
        emit(UserState.tokenLoaded(null));
      }
    });
  }

  Future<void> loadData({auth.User? user}) async {
    var token = user?.uid ?? state.token;
    if (token != null) {
      firestore.getDataById(token).then((value) {
        emit(
            UserState.dataLoaded(user: User.fromSnapshot(value), token: token));
      }).catchError(onHandleError);
    } else {
      emit(UserState.dataLoaded(user: null, token: null));
    }
  }

  Future<void> loadDataByUserID(String? token) async {
    if (token != null) {
      firestore.getDataById(token).then((value) {
        emit(
            UserState.dataLoaded(user: User.fromSnapshot(value), token: token));
      }).catchError(onHandleError);
    } else {
      emit(UserState.dataLoaded(user: null, token: null));
    }
  }

  Future<void> updateUserInfo(String? token,
      {String? name,
      String? surname,
      String? phonenumber,
      String? gender,
      var birthday}) async {
    emit(state.setRequestInProgress() as UserState);
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "surname": surname,
      "phone number": phonenumber,
      "gender": gender,
      "birthday": birthday,
      'id': token,
      "photo": "",
    };
    await firestore.setWithId(token, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> updateUserInfoMangoPay(String? token,
      {String? mangoPayId}) async {
    emit(state.setRequestInProgress() as UserState);
    Map<String, dynamic> data = <String, dynamic>{
      'id': token,
      "mangoPayId": mangoPayId,
    };
    await firestore.setWithId(token, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> addId(File? file, String ref, var token) async {
    if (file == null) return;
    final filename = basename(file.path);
    final destination = '$ref/$filename';
    emit(state.setRequestInProgress() as UserState);
    UploadTask? task = StorageService(destination).uploadFile(file);
    // ignore: unnecessary_null_comparison
    if (task == null) return;
    task.then((value) async {
      var url = await value.ref.getDownloadURL();
      Map<String, dynamic> data = <String, dynamic>{
        "$ref": url,
        "verified": false,
        "banned": false,
      };
      await firestore.setWithId(token, data: data);
      emit(UserState.dataLoaded(user: state.user, token: state.token));
    });
  }
}
