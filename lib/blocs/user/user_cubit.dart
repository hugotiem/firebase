import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'user_state.dart';

class UserCubit extends AppBaseCubit<UserState> {
  UserCubit() : super(UserState.initial());

  AuthService service = AuthService();
  FireStoreServices firestore = FireStoreServices("user");

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

  Future<void> updateUserInfo({String name, String surname}) async {
    emit(state.setRequestInProgress());
    var id = await service.getToken();
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      // "surname": surname,
    };
    await firestore.setWithId(id, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }

  Future<void> addIdRef() async {
    emit(state.setRequestInProgress());
    var id = await service.getToken();
    Map<String, dynamic> data = <String, dynamic>{
      "idRef": "id",
    };
    await firestore.setWithId(id, data: data);
    emit(UserState.dataLoaded(user: state.user, token: state.token));
  }
}
