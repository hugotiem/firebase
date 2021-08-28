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
    service.getToken().then(
        (value) => emit(UserState.dataLoaded(token: value, user: state.user)));
    print("token : " + state.token);
    service.instance.authStateChanges().listen((user) async {
      if (user != null) {
        user.getIdToken().then((value) =>
            emit(UserState.dataLoaded(token: value, user: state.user)));
        await this.loadData();
      }
    });
  }

  Future<void> loadData() async {
    var token = await service.currentUser.getIdToken();
    firestore.getDataById(token).then((value) {
      emit(UserState.dataLoaded(
          user: User.fromSnapshot(value), token: state.token));
    }).catchError(onHandleError);
  }
}
