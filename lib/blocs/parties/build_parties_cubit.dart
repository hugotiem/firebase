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
    var party = state.party?..name = name;
    emit(BuildPartiesState.loaded(party));
  }

  void setTheme(String? theme) {
    var party = state.party?..theme = theme;
    emit(BuildPartiesState.loaded(party));
  }

  void setDate(DateTime date) {
    var party = state.party?..date = date;
    emit(BuildPartiesState.loaded(party));
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
