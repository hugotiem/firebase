import 'package:pts/models/party.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/firestore_service.dart';
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
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future fetchPartiesByOrder() async {
    var partiesSnapShots = await services.getDataByOrder();
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties, state.filters));
  }

  // Future fetchPartiesByIdentifier(String id) async {
  //   var parties =
  //       await services.firestore.collection(services.collection).doc(id).get();
  //   emit(PartiesState.loaded(parties, state.filters));
  // }

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
      emit(PartiesState.loaded(parties, state.filters));
    } else {
      return parties;
    }
  }

  // Future fetchPartiesWithWhereIsEqualTo2(
  //     {var key1, dynamic data1, var key2, dynamic data2}) async {
  //   print("DATA 2 : $data2");
  //   if (data1 == null || data2 == null) {
  //     return;
  //   }
  //   if (data1 == 'uid') {
  //     data1 = await auth.getToken();
  //   }
  //   if (data2 == 'uid') {
  //     data2 = await auth.getToken();
  //   }
  //   emit(state.setRequestInProgress() as PartiesState);
  //   var partiesSnapShots =
  //       await services.getDataWithWhereIsEqualTo2(key1, data1, key2, data2);
  //   List<Party> parties =
  //       partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
  //   emit(PartiesState.loaded(parties, state.filters));
  // }

  Future fetchPartiesByDateWithWhereIsEqualTo(
      var key, String? data, DateTime date) async {
    List<Party> partiesWithDates = [];
    await fetchPartiesWithWhereIsEqualTo(key, data, isWithDate: true)
        .then((parties) {
      (parties as List<Party>).forEach((element) {
        if (isSameDay(element.date, date)) {
          partiesWithDates.add(element);
        }
      });
    });
    if (state.filters != null) {
      await applyFilters(state.filters!, filtersChanged: false);
    } else {
      emit(PartiesState.loaded(partiesWithDates, state.filters,
          currentDate: date));
    }
  }

  Future<void> applyFilters(Map<String, dynamic> filters,
      {bool filtersChanged = true}) async {
    if (filtersChanged) {
      emit(state.setRequestInProgress() as PartiesState);
    }
    var filteredParties =
        await services.getDataWithMultipleWhereIsEqualTo(filters);

    //  List<Party>.from(parties?.where((e) {
    //       print(e.theme);
    //       if ((filters['themes'] as List).contains(e.theme)) {
    //         return true;
    //       }
    //       return false;
    //     }).toList() ??
    //     []);

    var parties = filteredParties.docs.map<Party>((e) => Party.fromSnapShots(e)).toList();

    emit(PartiesState.loaded(parties, filters,
        currentDate: state.currentDate));
  }

  Future fetchPartiesWithWhereArrayContains(var key, String? token) async {
    var partiesSnapShots =
        await services.getDataWithWhereArrayContains(key, token);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties, state.filters));
  }
}
