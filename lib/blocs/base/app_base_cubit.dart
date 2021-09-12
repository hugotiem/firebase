import 'package:bloc/bloc.dart';
import 'package:pts/blocs/base/app_base_state.dart';

abstract class AppBaseCubit<U extends AppBaseState> extends Cubit<U> {
  AppBaseCubit(U initialState) : super(initialState);

  Future<Null> onHandleError(Object error, StackTrace stackTrace) async {
    emit(state.setRequestInProgress(inProgress: false));

    emit(state.setErrorReceived(
      requestFailureCode: error.toString(),
      requestFailureMessage: error.toString(),
    ));
  }

}
