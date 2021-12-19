part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded }

class SearchState extends AppBaseState {
  final List<PlaceSearch>? results;

  const SearchState(SearchStatus status,
      {this.results,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const SearchState.initial() : this(SearchStatus.initial);

  const SearchState.dataLoaded(List<PlaceSearch>? results)
      : this(SearchStatus.loaded, results: results);

  SearchState copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      SearchState(this.status,
          results: this.results,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
