import 'package:pts/Model/address.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'build_parties_state.dart';

class BuildPartiesCubit extends AppBaseCubit<BuildPartiesState> {
  BuildPartiesCubit() : super(BuildPartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");

  void addItem(String key, dynamic item) {
    var parties = state.parties ?? Map<String, dynamic>();
    emit(BuildPartiesState.adding());
    parties[key] = item;
    emit(BuildPartiesState.added(parties));
  }

  Future<List<Address>> searchAddress(String address) async {
    Uri url = Uri.parse(
        "https://api-adresse.data.gouv.fr/search/?q=${address.replaceAll(" ", "+")}");
    http.Response results = await http.get(url);
    Map<String, dynamic> json = convert.jsonDecode(results.body);

    List infos = json['features'];

    List<Address> addresses = (infos).map((e) {
      return Address.fromJson(e['properties'] as Map<String, dynamic>);
    }).toList();

    return addresses;
  }

  Future<void> addToFireStore() async {
    emit(state.setRequestInProgress());
    await services.add(data: state.parties).then(
          (_) => emit(BuildPartiesState.loaded(state.parties)),
        );
  }
}
