import 'package:flutter/material.dart';
import 'package:pts/const.dart';
import 'package:pts/models/calendar_data_source.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/models/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'calendar_state.dart';

class CalendarCubit extends AppBaseCubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial());

  FireStoreServices services = FireStoreServices("parties");

  Future<void> loadData() async {
    emit(state.setRequestInProgress() as CalendarState);
    var user = User();
    if (user.currentUser == null) {
      emit(state.setRequestInProgress(inProgress: false) as CalendarState);
      return;
    }
    var organisedPartiesData =
        await services.getDataWithWhereIsEqualTo('uid', user.id);
    var invitedPartiesData = await services.getDataWithWhereArrayContains(
        'validate guest list', user.name, user.id);

    var organisedParties = organisedPartiesData.docs
        .map((e) => Meeting.fromSnapShot(e, SECONDARY_COLOR))
        .toList();
    var invitedParties = invitedPartiesData.docs
        .map((e) => Meeting.fromSnapShot(e, Colors.pink))
        .toList();

    emit(CalendarState.dataLoaded(organisedParties, invitedParties));
  }
}
