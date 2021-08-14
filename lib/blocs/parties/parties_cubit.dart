import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'parties_state.dart';

class PartiesCubit extends AppBaseCubit<PartiesState> {
  PartiesCubit() : super(PartiesState.initial());

  FireStoreServices services = FireStoreServices("parties");

  void set(String key, dynamic item) {
    var parties = state.parties;
    emit(PartiesState.adding());
    parties[key] = item;
    emit(PartiesState.added(parties));
  }

  Future<void> addToFireStore() async {
    emit(state.setRequestInProgress());
    await services.add(data: state.parties).then(
          (_) => emit(PartiesState.loaded(state.parties)),
        );
  }
}
