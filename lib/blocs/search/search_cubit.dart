import 'package:pts/blocs/application_bloc.dart';
import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/place_search.dart';

part 'search_state.dart';

class SearchCubit extends AppBaseCubit<SearchState> {
  SearchCubit() : super(SearchState.initial());

  final ApplicationBloc applicationBloc = new ApplicationBloc();

  Future fetchResults(String? search) async {
    emit(state.setRequestInProgress() as SearchState);
    if (search != null) await applicationBloc.searchPlaces(search);
    emit(SearchState.resultsLoaded(
        applicationBloc.searchResults, state.destination, state.last));
  }

  void updateDestination({String? destination, String? last}) async {
    emit(SearchState.destinationChanged(state.results, destination, last));
  }
}
