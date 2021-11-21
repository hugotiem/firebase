import 'dart:io';

import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/Model/services/storage_service.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:path/path.dart';

part 'user_state.dart';

class UserCubit extends AppBaseCubit<UserState> {
  UserCubit() : super(UserState.initial());

  final AuthService service = AuthService();
  final FireStoreServices firestore = FireStoreServices("user");

  Future<void> init() async {
    await service
        .getToken()
        .then((value) => emit(UserState.tokenLoaded(value)));
    print("token : " + state.token.toString());
    service.instance.authStateChanges().listen((user) async {
      print("Current user : " + user.toString());
      if (user != null) {
        await this.loadData(user: user);
      }
    });
  }

  Future<void> loadData({var user}) async {
    var token = user?.uid ?? await service.getToken();
    firestore.getDataById(token).then((value) {
      emit(UserState.dataLoaded(user: User.fromSnapshot(value), token: token));
    }).catchError(onHandleError);
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

  Future<void> addId(File file, String ref) async {
    final filename = basename(file.path);
    final destination = '$ref/$filename';
    emit(state.setRequestInProgress() as UserState);
    var task = StorageService(destination).uploadFile(file);
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
