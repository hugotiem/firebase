import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/services/payment_service.dart';
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

  final PaymentService _paymentService = PaymentService();

  Future<void> init() async {
    await service.getToken().then((value) {
      emit(UserState.dataLoaded(
          token: value, user: state.user, wallet: state.wallet));
    });
    service.instance.authStateChanges().listen((user) async {
      if (user != null) {
        emit(state.setRequestInProgress() as UserState);
        service.setToken(user.uid);
        await this.loadData(user: user);
      } else {
        await service.deleteToken();
        emit(UserState.dataLoaded(token: state.token));
      }
    });
  }

  Future<void> loadData({auth.User? user}) async {
    var token = user?.uid ?? state.token;
    print("USER LOGGED");
    if (token != null) {
      firestore.getDataById(token).then((value) async {
        var user = User.fromSnapshot(value);
        var wallet =
            await _paymentService.getWalletByUserId(user.mangoPayId ?? "");
        emit(UserState.dataLoaded(
            user: user, token: token, wallet: wallet?[WalletType.MAIN]));
      }).catchError(onHandleError);
    } else {
      emit(UserState.dataLoaded(user: null, token: null));
    }
  }

  Future<void> loadDataByUserID(String? token) async {
    if (token != null) {
      firestore.getDataById(token).then((value) async {
        var user = User.fromSnapshot(value);
        var wallet =
            await _paymentService.getWalletByUserId(user.mangoPayId ?? "");

        emit(UserState.dataLoaded(
            user: user, token: token, wallet: wallet?[WalletType.MAIN]));
      }).catchError(onHandleError);
    } else {
      emit(UserState.dataLoaded());
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
      "desc": "",
    };
    await firestore.setWithId(token, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> updatedesc(String token, String desc) async {
    emit(state.setRequestInProgress() as UserState);
    Map<String, String> data = <String, String>{"desc": desc};
    await firestore.setWithId(token, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> updateUserInfoMangoPay(String? token,
      {String? mangoPayId}) async {
    emit(state.setRequestInProgress() as UserState);
    Map<String, dynamic> data = <String, dynamic>{
      'id': token,
      "mangoPayId": mangoPayId,
      "verified": false,
    };
    await firestore.setWithId(token, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> sendId2Mangopay(
      String? mangopayId, File idRecto, File idVerso) async {
    if (mangopayId == null) {
      return emit(UserState.failed());
    }
    await _paymentService
        .submitKYCDocument(mangopayId, idRecto, verso: idVerso)
        .then((value) {
      if (value == QueryState.success) {
        return emit(UserState.idUploaded(user: state.user, token: state.token));
      }
      return emit(UserState.failed());
    });
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
        "banned": false,
      };
      await firestore.setWithId(token, data: data);
      emit(UserState.idUploaded(user: state.user, token: state.token));
    });
  }

  Future<String?> getUserToken() async {
    return await service.getToken();
  }

  Future<bool> hasToken() async {
    var token = await getUserToken();
    return token != null;
  }

  Future<void> logout() async {
    await service.deleteToken();
    await service.instance.signOut();
    emit(UserState.dataLoaded());
  }
}
