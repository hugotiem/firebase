import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

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

  Future<void> addToFireStore() async {
    emit(state.setRequestInProgress());
    await services.add(data: state.parties).then(
          (_) => emit(BuildPartiesState.loaded(state.parties)),
        );
  }
}
