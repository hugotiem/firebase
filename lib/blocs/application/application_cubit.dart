import 'package:firebase_auth/firebase_auth.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/managers/analytics_manager.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/firestore_service.dart';

import 'package:pts/models/user.dart' as app;

part 'application_state.dart';

class ApplicationCubit extends AppBaseCubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.initial());

  FireStoreServices _services = FireStoreServices("user");
  AuthService _authService = AuthService();

  Future<void> launch() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await _authService.setToken(user.uid);
        await _services.getDataById(user.uid).then((snapshot) {
          var appUser = app.User.fromSnapshot(snapshot);
          FirebaseAnalyticsImplementation().init(user: appUser);
          emit(ApplicationState.main(appUser));
        }).catchError(onHandleError);
      } else {
        emit(ApplicationState.login());
      }
    });
  }
}
