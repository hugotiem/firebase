import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/components/app_datetime.dart';
import 'package:pts/models/city.dart';
import 'package:pts/models/party.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/user.dart';

part 'parties_state.dart';

class PartiesCubit extends AppBaseCubit<PartiesState> {
  PartiesCubit(
      {AuthService? auth,
      FireStoreServices? services,
      FireStoreServices? userServices})
      : super(PartiesState.initial()) {
    this.auth = auth ?? AuthService();
    this.services = services ?? FireStoreServices("parties");
    this.userServices = userServices ?? FireStoreServices("user");
  }

  late FireStoreServices services;
  late FireStoreServices userServices;
  late AuthService auth;

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future fetchParties() async {
    var partiesSnapShots = await services.getData();
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future disablePartiesAfterDate() async {
    var partiesSnapshots = await services.getActiveData();
    DateTime now = DateTime.now();
    List<Party> parties =
        partiesSnapshots.docs.map((e) => Party.fromSnapShots(e)).toList();
    parties.map((e) async {
      DateTime startTime = e.startTime!;
      if (startTime.isBefore(now)) {
        await services.updateValue(e.id, {"isActive": false});
      }
    }).toList();
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future fetchActiveParties() async {
    var partiesSnapShots = await services.getActiveData();
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
      {bool isActive = false}) async {
    if (data == null) {
      return;
    }
    if (data == 'uid') {
      data = await auth.getToken();
    }
    emit(state.setRequestInProgress() as PartiesState);
    QuerySnapshot<Map<String, dynamic>> partiesSnapShots;
    if (isActive) {
      partiesSnapShots =
          await services.getDataWithWhereIsEqualToAndIsActive(key, data);
    } else {
      partiesSnapShots = await services.getDataWithWhereIsEqualTo(key, data);
    }

    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future fetchPartiesWithWhereIsEqualToAndIsActive(
      var key, String? data) async {
    fetchPartiesWithWhereIsEqualTo(key, data, isActive: true);
  }

  Future<List<City>> fetchCitiesByPartiesNumber() async {
    List<String> cities = [
      "Paris",
      "Lyon",
      "Bordeaux",
      "Lille",
      "Marseille",
      "Nice",
      "Toulouse",
      "Nantes",
      "Montpellier",
      "Strasbourg",
    ];

    Map<String, int> map = {};

    for (var city in cities) {
      var count = await services.getCountOf("city", city);
      if (count > 0) {
        map[city] = count;
      }
    }

    var entries = map.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));

    return entries.map((e) => City(e.key, e.value)).toList();
  }

  Future<void> fetchPartiesByDateWithWhereIsEqualTo(
      var key, String? data, DateTime date) async {
    var snapshots = await services.getDataBeforeDateWithWhereIsEqualTo(
        key, data, AppDateTime.from(date).yMd());

    var parties = snapshots.docs.map((e) => Party.fromSnapShots(e)).toList();
    if (state.filters != null) {
      await applyFilters(state.filters!, filtersChanged: false);
    } else {
      emit(PartiesState.loaded(parties, state.filters, currentDate: date));
    }
  }

  Future<void> fetchPartiesByMonthsWithWhereIsEqualTo(
      var key, String? data, List<DateTime> dates) async {
    List<Party> parties = [];
    for (var date in dates) {
      var snapshot = await services.getDataByDateWithWhereEqualsToAndIsActive(
          key, data?.split(",")[0], AppDateTime.from(date).yM());
      parties.addAll(snapshot.docs.map((e) => Party.fromSnapShots(e)).toList());
    }
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future<void> applyFilters(Map<String, dynamic> filters,
      {bool filtersChanged = true}) async {
    if (filtersChanged) {
      emit(state.setRequestInProgress() as PartiesState);
    }
    var filteredParties =
        await services.getDataWithMultipleWhereIsEqualTo(filters);

    var parties =
        filteredParties.docs.map<Party>((e) => Party.fromSnapShots(e)).toList();

    emit(PartiesState.loaded(parties, filters, currentDate: state.currentDate));
  }

  Future fetchPartiesWithWhereArrayContains(var key, String? token,
      {bool userLink = false}) async {
    var partiesSnapShots =
        await services.getDataWithWhereMapContains(key, token);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    if (userLink) {
      // parties.forEach((element) {
      //   element.userLink =
      //       'https://ptsapp.page.link/?link=pts.com?token=${element.validatedListInfo[token]["token"]}&apn=pts-beta-yog&ibi=com.yog.pts';
      // });
    }
    emit(PartiesState.loaded(parties, state.filters));
  }

  Future<Party> fetchPartyById(String id) async {
    var data = await services.getDataById(id);
    Party party = Party.fromDocument(data);
    return party;
  }

  Future<void> addComment(
      User? user, Party party, double note, String comment) async {
    emit(state.setRequestInProgress() as PartiesState);
    await services.setWithId(party.id, data: {
      "commentIdList": FieldValue.arrayUnion([user!.id]),
    });
    await services.setWithId(party.id,
        data: {
          "note": note,
          "comment": comment,
          "name": user.name,
          "surname": user.surname,
          "photo": user.photo
        },
        path: "comment.${user.id}");
    emit(PartiesState.loaded(state.parties, state.filters));
  }

  Future<void> addUserInWaitList(User user, Party party) async {
    emit(state.setRequestInProgress() as PartiesState);
    await services.setWithId(party.id, data: {
      "waitList": FieldValue.arrayUnion([user.id]),
    });

    await services.setWithId(party.id,
        data: {
          "name": user.name,
          "surname": user.surname,
          "photo": user.photo,
          "gender": user.gender,
        },
        path: "waitListInfo.${user.id}");
    emit(PartiesState.loaded(state.parties, state.filters));
  }

  Future<void> addUserInValidatedList(
      Map<String, dynamic> infos, Party party) async {
    emit(state.setRequestInProgress() as PartiesState);
    await services.setWithId(party.id, data: {
      'validatedList': FieldValue.arrayUnion([infos['id']]),
    });

    await services.setWithId(party.id,
        data: {
          "token":
              "${party.name!.replaceAll(" ", "_").substring(0, party.name!.length < 5 ? party.name!.length : 5)}${getRandomString(5)}",
          "name": infos['name'],
          "surname": infos['surname'],
          "photo": infos['photo'],
          "gender": infos['gender'],
        },
        path: "validatedListInfo.${infos['id']}");

    removeUserFromWaitList(party, infos['id'], fromBloc: true);
  }

  Future<void> removeUserFromWaitList(Party party, String userId,
      {bool fromBloc = false}) async {
    if (!fromBloc) emit(state.setRequestInProgress() as PartiesState);
    await services.setWithId(party.id, data: {
      'waitList': FieldValue.arrayRemove([userId])
    });

    await services.deleteValue(party.id!, "waitListInfo.$userId");
    emit(PartiesState.loaded(state.parties, state.filters));
    // Map<String, dynamic> map = party.waitListInfo..remove(userId);
    // await services.setWithId(party.id, data: {
    //   'waitListInfo': map,
    // });
  }

  Future<void> createQrCodeLink() async {}
  Future updateParty(String id, Map<String, dynamic> data) async {
    await services.updateValue(id, data);
  }
}
