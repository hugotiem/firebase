import 'package:firebase_auth/firebase_auth.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/services/firestore_service.dart';

import 'package:pts/models/user.dart' as app;

part 'application_state.dart';

class ApplicationCubit extends AppBaseCubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.initial());

  FireStoreServices _services = FireStoreServices("user");

  Future<void> launch() async {
    print("LAUNCH");
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      print("user: $user");
      if (user != null) {
        await _services.getDataById(user.uid).then((snapshot) {
          var appUser = app.User.fromSnapshot(snapshot);
          emit(ApplicationState.main(appUser));
        }).catchError(onHandleError);
      } else {
        emit(ApplicationState.login());
      }
    });
  }
}
