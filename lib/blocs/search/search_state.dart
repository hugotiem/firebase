part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, changed }

class SearchState extends AppBaseState {
  final String? destination;
  final List<PlaceSearch>? results;

  const SearchState(SearchStatus status,
      {this.results,
      this.destination,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const SearchState.initial() : this(SearchStatus.initial);

  const SearchState.resultsLoaded(
      List<PlaceSearch>? results, String? destination)
      : this(SearchStatus.loaded, results: results, destination: destination);

  const SearchState.destinationChanged(
      List<PlaceSearch>? results, String? destination)
      : this(SearchStatus.changed, results: results, destination: destination);

  SearchState copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      SearchState(this.status,
          results: this.results,
          destination: this.destination,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
