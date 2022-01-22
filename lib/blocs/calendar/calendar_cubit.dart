import 'package:pts/const.dart';
import 'package:pts/models/calendar_data_source.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'calendar_state.dart';

class CalendarCubit extends AppBaseCubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial());

  FireStoreServices services = FireStoreServices("parties");
  FireStoreServices userServices = FireStoreServices("user");
  AuthService auth = AuthService();

  Future<void> loadData() async {
    emit(state.setRequestInProgress() as CalendarState);
    var token = await auth.getToken();
    if (token != null) {
      if (auth.currentUser == null) {
        emit(state.setRequestInProgress(inProgress: false) as CalendarState);
        return;
      }
      var organisedPartiesData = await services.getDataWithWhereIsEqualTo(
          'party owner', token);
      var invitedPartiesData = await services.getDataWithWhereMapContains(
          'validate guest list', token);

      var organisedParties = organisedPartiesData.docs
          .map((e) => Meeting.fromSnapShot(e, ICONCOLOR))
          .toList();
      var invitedParties = invitedPartiesData.docs
          .map((e) => Meeting.fromSnapShot(e, SECONDARY_COLOR))
          .toList();
      emit(CalendarState.dataLoaded(organisedParties, invitedParties));
    }
  }
}
