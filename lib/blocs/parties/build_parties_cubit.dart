import 'package:pts/models/address.dart';
import 'package:pts/models/party.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'build_parties_state.dart';

class BuildPartiesCubit extends AppBaseCubit<BuildPartiesState> {
  BuildPartiesCubit() : super(BuildPartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");

  void setName(String? name) {
    var party = (state.party ?? Party()).copyWith(name: name);
    emit(BuildPartiesState.added(party));
  }

  void setTheme(String? theme) {
    var party = (state.party ?? Party());
    party = party.copyWith(theme: theme);
    emit(BuildPartiesState.added(party));
  }

  void setDate(DateTime date) {
    var party = (state.party ?? Party()).copyWith(date: date);
    print(party.date);
    emit(BuildPartiesState.added(party));
  }

  void setStartTime(DateTime startTime, DateTime endTime) {
    var party = (state.party ?? Party()).copyWith(startTime: startTime, endTime: endTime);
    emit(BuildPartiesState.added(party));
  }

  void setAddress(String address, String postalCode, String city, List<double?>? coordinates) {
    var party = (state.party ?? Party())
        .copyWith(address: address, postalCode: postalCode, city: city, coordinates: coordinates);
    emit(BuildPartiesState.added(party));
  }

  void setNumber(int number) {
    var party = (state.party ?? Party()).copyWith(number: number);
    emit(BuildPartiesState.added(party));
  }

  void setPrice(double price) {
    var party = (state.party ?? Party()).copyWith(price: price);
    emit(BuildPartiesState.added(party));
  }

  void setAnimals(AnimalState animal) {
    var party = (state.party ?? Party()).copyWith(animals: animal);
    emit(BuildPartiesState.added(party));
  }

  void setSmoke(SmokeState smoke) {
    var party = (state.party ?? Party()).copyWith(smoke: smoke);
    emit(BuildPartiesState.added(party));
  }

  void setDesc(String desc) {
    var party = (state.party ?? Party()).copyWith(desc: desc);
    emit(BuildPartiesState.added(party));
  }

  void setOwnerId(String? id) {
    var party = (state.party ?? Party()).copyWith(ownerId: id);
    emit(BuildPartiesState.added(party));
  }

  void setWaitList() {
    var party = (state.party ?? Party()).copyWith(waitList: [], waitListInfo: {}, validatedList: [], validatedListInfo: {});
    emit(BuildPartiesState.added(party));
  }

  void setisActive() {
    var party = (state.party ?? Party()).copyWith(isActive: true);
    emit(BuildPartiesState.added(party));
  }

  void setComment() {
    var party = (state.party ?? Party()).copyWith(commentIdList: [], comment: {});
    emit(BuildPartiesState.added(party));
  }

  // var set

  Future<List<Address>> searchAddress(String address) async {
    Uri url = Uri.parse(
        "https://api-adresse.data.gouv.fr/search/?q=${address.replaceAll(" ", "+")}");
    http.Response results = await http.get(url);
    Map<String, dynamic> json = convert.jsonDecode(results.body);

    List infos = json['features'];

    List<Address> addresses = (infos).map((e) {
      return Address.fromJson(e as Map<String, dynamic>);
    }).toList();

    return addresses;
  }

  Future<void> addToFireStore() async {
    emit(state.setRequestInProgress() as BuildPartiesState);
    await services.add(data: state.party?.toJson()).then(
          (_) => emit(BuildPartiesState.loaded(state.party)),
        );
  }
}
