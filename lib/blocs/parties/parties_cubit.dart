import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Model/party.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'parties_state.dart';

class PartiesCubit extends AppBaseCubit<PartiesState> {
  PartiesCubit() : super(PartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");

  Future fetchParties() async {
    emit(state.setRequestInProgress());
    var partiesSnapShots = await services.getData();
    List<Party> parties = partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByOrder() async {
    emit(state.setRequestInProgress());
    var partiesSnapShots = await services.getDataByOrder();
    List<Party> parties = partiesSnapShots.docs.map((e) => Party.fromSnapShots(e)).toList();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByIdentifier(String id) async {
    emit(state.setRequestInProgress());
    var parties =
        await services.firestore.collection(services.collection).doc(id).get();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesWithWhere(var key, String data) async {
    emit(state.setRequestInProgress());
    var partiesSnapShots = await services.getDataWithWhere(key, data);
    List<Party> parties = partiesSnapShots.docs.map((e) => Party.fromSnapShots(e));
    emit(PartiesState.loaded(parties));
  }
}
