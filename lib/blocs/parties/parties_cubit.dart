import 'package:pts/models/party.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/models/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:table_calendar/table_calendar.dart';

part 'parties_state.dart';

class PartiesCubit extends AppBaseCubit<PartiesState> {
  PartiesCubit() : super(PartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");
  FireStoreServices userServices = FireStoreServices("user");
  AuthService auth = AuthService();

  Future fetchParties() async {
    var partiesSnapShots = await services.getData();
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByOrder() async {
    var partiesSnapShots = await services.getDataByOrder();
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByIdentifier(String id) async {
    var parties =
        await services.firestore.collection(services.collection).doc(id).get();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesWithWhereIsEqualTo(var key, String? data,
      {isWithDate = false}) async {
    if (data == null) {
      return;
    }
    if (data == 'uid') {
      data = await auth.getToken();
    }
    emit(state.setRequestInProgress() as PartiesState);
    var partiesSnapShots = await services.getDataWithWhereIsEqualTo(key, data);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    if (!isWithDate) {
      emit(PartiesState.loaded(parties));
    } else {
      return parties;
    }
  }

  Future fetchPartiesWithWhereIsEqualTo2(
      {var key1, dynamic data1, var key2, dynamic data2}) async {
    print("DATA 2 : $data2");
    if (data1 == null || data2 == null) {
      return;
    }
    if (data1 == 'uid') {
      data1 = await auth.getToken();
    }
    if (data2 == 'uid') {
      data2 = await auth.getToken();
    }
    emit(state.setRequestInProgress() as PartiesState);
    var partiesSnapShots =
        await services.getDataWithWhereIsEqualTo2(key1, data1, key2, data2);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByDateWithWhereIsEqualTo(
      var key, String? data, DateTime date) async {
    List<Party> partiesWithDates = [];
    await fetchPartiesWithWhereIsEqualTo(key, data, isWithDate: true)
        .then((parties) {
      print("parties size ${parties?.length}");
      (parties as List<Party>).forEach((element) {
        if (isSameDay(element.date, date)) {
          partiesWithDates.add(element);
        }
      });
    });
    emit(PartiesState.loaded(partiesWithDates));
  }

  Future fetchCurrentPartiesWithDateEqualTo(DateTime date) async {
    emit(state.setRequestInProgress() as PartiesState);
    List<Party> partiesWithDates = [];
    var parties = state.parties;
    parties?.forEach((element) {
      if (isSameDay(element.date, date)) {
        partiesWithDates.add(element);
      }
    });
    emit(PartiesState.loaded(partiesWithDates));
  }

  Future fetchPartiesWithWhereArrayContains(var key) async {
    var token = await auth.getToken();
    var data = await userServices.getDataById(token);
    var user = User.fromSnapshot(data);
    var partiesSnapShots =
        await services.getDataWithWhereArrayContains(key, user.name, user.id);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }
}
