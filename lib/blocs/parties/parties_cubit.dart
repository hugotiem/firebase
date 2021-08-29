import 'package:pts/Model/party.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

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

  Future fetchPartiesWithWhereIsEqualTo(var key, String data) async {
    if (data == 'uid') {
      data = await auth.getToken();
    }
    var partiesSnapShots = await services.getDataWithWhereIsEqualTo(key, data);
    List<Party> parties =
        partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
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
