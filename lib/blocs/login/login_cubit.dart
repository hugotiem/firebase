import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'login_state.dart';

class LoginCubit extends AppBaseCubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  final AuthService auth = AuthService();
  final FireStoreServices fireStoreServices = FireStoreServices("user");

  Future<void> register(String email, String password) async {
    emit(state.setRequestInProgress() as LoginState);
    await auth.register(email, password).then((value) async {
      await addUserAfterRegistration(value);
    }).onError(onHandleError);
  }

  Future<void> signIn(String email, String password) async {
    await auth.signIn(email, password).then((value) async {
      await auth.setToken(value!.uid);
      emit(LoginState.logged());
    }).onError((onHandleError));
  }

  Future<void> signInWithGoogle() async {
    await auth.signInWithGoogle().then((value) async {
      var user = value.user!;
      await auth.setToken(user.uid);
      var res = await fireStoreServices.getDataById(user.uid);
      if (res.exists) {
        emit(LoginState.logged());
      } else {
        addUserAfterRegistration(user, fromGoogle: true);
      }
    }).catchError(onHandleError);
  }

  Future<void> addUserAfterRegistration(var user,
      {bool fromGoogle = false}) async {
    Map<String, dynamic> data = {
      "email": user.email,
      if (fromGoogle) "name": user.displayName.toString().split(" ")[0],
      if (fromGoogle) "surname": user.displayName.toString().split(" ")[1]
    };
    await fireStoreServices.setWithId(user.uid, data: data);
    emit(LoginState.signedUp());
  }
}
