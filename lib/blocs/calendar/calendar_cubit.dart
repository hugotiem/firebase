import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'calendar_state.dart';

class CalendarCubit extends AppBaseCubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial());

  FireStoreServices services = FireStoreServices("parties");

  Future<void> loadData() async {
    emit(state.setRequestInProgress());
    var user = await User().currentUser;

    var organisedPartiesData =
        await services.getDataWithWhereIsEqualTo('uid', user.id);
    var invitedPartiesData = await services.getDataWithWhereArrayContains(
        'validate guest list', user.name, user.id);

    var organisedParties =
        organisedPartiesData.docs.map((e) => Meeting.fromSnapShot(e, SECONDARY_COLOR));
    var invitedParties =
        invitedPartiesData.docs.map((e) => Meeting.fromSnapShot(e, Colors.pink));

    emit(CalendarState.dataLoaded(organisedParties, invitedParties));
  }
}
