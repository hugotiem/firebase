import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'login_state.dart';

class LoginCubit extends AppBaseCubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  final AuthService auth = AuthService();

  Future<void> register(String email, String password) async {
    emit(state.setRequestInProgress());
    await auth
        .register(email, password)
        .then((value) => emit(LoginState.signedUp()))
        .onError(onHandleError);
  }

  Future<void> signIn(String email, String password) async {
    await auth
        .signIn(email, password)
        .then((value) => emit(LoginState.logged()))
        .onError((onHandleError));
  }

  Future<void> signInWithGoogle(bool isRegister) async {
    await auth
        .signInWithGoogle()
        .then((_) => isRegister ? LoginState.signedUp() : LoginState.logged())
        .catchError(onHandleError);
  }
}
