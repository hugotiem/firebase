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

  Future<bool> isLogged() async {
    String token = await service.getToken();
    if (token != null) {
      if (service.currentUser != null) {
        return true;
      }
    }
    return false;
  }

  Future<void> loadData() async {
    bool isLogged = await this.isLogged();
    if (isLogged) {
      var token = await service.currentUser.getIdToken();
      firestore.getDataById(token).then((value) {
        emit(UserState.dataLoaded(User.fromSnapshot(value)));
      }).catchError(onHandleError);
    }
  }
}
