import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'parties_state.dart';

class PartiesCubit extends AppBaseCubit<PartiesState> {
  PartiesCubit() : super(PartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");

  Future fetchParties() async {
    emit(state.setRequestInProgress());
    var parties =
        await services.firestore.collection(services.collection).get();
    emit(PartiesState.loaded(parties));
  }

  Future fetchPartiesByIdentifier(String id) async {
    emit(state.setRequestInProgress());
    var parties =
        await services.firestore.collection(services.collection).doc(id).get();
    emit(PartiesState.loaded(parties));
  }
}
